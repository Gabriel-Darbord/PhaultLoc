Class {
	#name : 'BaselineOfPhaultLoc',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPhaultLoc',
	#package : 'BaselineOfPhaultLoc'
}

{ #category : 'baselines' }
BaselineOfPhaultLoc >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'PhaultLoc'
			with: [ spec requires: #( 'CodeCoverage' ) ].

		spec
			baseline: 'CodeCoverage'
			with: [ spec repository: 'github://alamvic/CodeCoverage:main/src' ].

		spec
			group: 'core' with: #( 'PhaultLoc' );
			group: 'default' with: #( 'core' ) ]
]
