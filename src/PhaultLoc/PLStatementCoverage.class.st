Class {
	#name : 'PLStatementCoverage',
	#superclass : 'Object',
	#instVars : [
		'executedPasses',
		'executedFails',
		'nonExecutedPasses',
		'nonExecutedFails'
	],
	#category : 'PhaultLoc',
	#package : 'PhaultLoc'
}

{ #category : 'api' }
PLStatementCoverage class >> sortByOchiaiScore: statementsWithScore [
	"From most to least suspicious."

	^ statementsWithScore associations sorted: [ :a :b |
		  a value ochiaiScore >= b value ochiaiScore ]
]

{ #category : 'api' }
PLStatementCoverage class >> sortByTarantulaScore: statementsWithScore [
	"From most to least suspicious."

	^ statementsWithScore associations sorted: [ :a :b |
		  a value tarantulaScore >= b value tarantulaScore ]
]

{ #category : 'api' }
PLStatementCoverage class >> statementCoverageOfMethods: methods withTests: tests [
	"Associate the statements of the methods with the given tests.
	For each statement, distinguish which tests cover it and which do not, and whether they pass or fail."

	| coverages |
	coverages := Dictionary new.
	methods do: [ :method |
		| statements |
		statements := method ast allSequenceNodes flatCollect: [ :s |
			              Array with: s withAll: s statements ].
		tests do: [ :test |
			| rawCoverages result |
			rawCoverages := LineCoverage
				                measureCoverageOfMethods: { method }
				                during: [ result := test run ].
			statements
				with: (rawCoverages coverageOf: method)
				do: [ :statement :rawCoverage |
					| coverage testMethod |
					coverage := coverages at: statement ifAbsentPut: [ self new ].
					testMethod := test class >> test selector.
					rawCoverage
						ifNotNil: [ "statement has been executed"
							result hasPassed
								ifTrue: [ coverage addExecutedPass: testMethod ]
								ifFalse: [ coverage addExecutedFail: testMethod ] ]
						ifNil: [ "statement not executed"
							result hasPassed
								ifTrue: [ coverage addNonExecutedPass: testMethod ]
								ifFalse: [ coverage addNonExecutedFail: testMethod ] ] ] ] ].
	^ coverages
]

{ #category : 'accessing' }
PLStatementCoverage >> addExecutedFail: aTest [

	^ executedFails add: aTest
]

{ #category : 'accessing' }
PLStatementCoverage >> addExecutedPass: aTest [

	^ executedPasses add: aTest
]

{ #category : 'accessing' }
PLStatementCoverage >> addNonExecutedFail: aTest [

	^ nonExecutedFails add: aTest
]

{ #category : 'accessing' }
PLStatementCoverage >> addNonExecutedPass: aTest [

	^ nonExecutedPasses add: aTest
]

{ #category : 'accessing' }
PLStatementCoverage >> executedFails [

	^ executedFails
]

{ #category : 'accessing' }
PLStatementCoverage >> executedFails: aTestCollection [

	executedFails := aTestCollection
]

{ #category : 'accessing' }
PLStatementCoverage >> executedPasses [

	^ executedPasses
]

{ #category : 'accessing' }
PLStatementCoverage >> executedPasses: aTestCollection [

	executedPasses := aTestCollection
]

{ #category : 'initialization' }
PLStatementCoverage >> initialize [

	executedPasses := OrderedCollection new: 0.
	executedFails := OrderedCollection new: 0.
	nonExecutedPasses := OrderedCollection new: 0.
	nonExecutedFails := OrderedCollection new: 0
]

{ #category : 'accessing' }
PLStatementCoverage >> nonExecutedFails [

	^ nonExecutedFails
]

{ #category : 'accessing' }
PLStatementCoverage >> nonExecutedFails: aTestCollection [

	nonExecutedFails := aTestCollection
]

{ #category : 'accessing' }
PLStatementCoverage >> nonExecutedPasses [

	^ nonExecutedPasses
]

{ #category : 'accessing' }
PLStatementCoverage >> nonExecutedPasses: aTestCollection [

	nonExecutedPasses := aTestCollection
]

{ #category : 'scoring' }
PLStatementCoverage >> ochiaiScore [
	"ep(s) and ef(s) are the numbers of passed and failed tests that execute statement s.
	np(s) and nf(s) are the numbers of passed and failed tests that do not execute statement s.
	ef(s) / sqrt( (ef(s) + nf(s)) * (ef(s) + ep(s)) )"

	| divisor |
	divisor := (executedFails size + nonExecutedFails size)
	           * (executedFails size + executedPasses size).
	divisor = 0 ifTrue: [ ^ 0 ].
	^ executedFails size / divisor sqrt
]

{ #category : 'printing' }
PLStatementCoverage >> printOn: stream [

	stream
		nextPutAll: '[ep:';
		nextPutAll: executedPasses size asString;
		nextPutAll: ',ef:';
		nextPutAll: executedFails size asString;
		nextPutAll: ',np:';
		nextPutAll: nonExecutedPasses size asString;
		nextPutAll: ',nf:';
		nextPutAll: nonExecutedFails size asString;
		nextPut: $]
]

{ #category : 'scoring' }
PLStatementCoverage >> tarantulaScore [
	"(ef / (ef + nf)) / ((ef / (ef + nf)) + (ep / (ep + np)))"

	| dividend divisor subDivisor |
	(divisor := executedFails size + nonExecutedFails size) = 0 ifTrue: [
		^ 0 ].
	dividend := executedFails size / divisor.
	(subDivisor := executedPasses size + nonExecutedPasses size) = 0
		ifTrue: [ ^ 0 ].
	(divisor := dividend + (executedPasses size / subDivisor)) = 0
		ifTrue: [ ^ 0 ].
	^ dividend / divisor
]
