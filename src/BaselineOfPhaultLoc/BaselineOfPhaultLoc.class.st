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
		spec package: 'PhaultLoc' with: [ spec requires: #( 'Coverage' ) ].

		spec
			baseline: 'Coverage'
			with: [ spec repository: 'github://Alamvic/coverage:main/src' ].

		spec
			group: 'core' with: #( 'PhaultLoc' );
			group: 'default' with: #( 'core' ) ]
]
