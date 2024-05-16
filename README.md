# PhaultLoc
Coverage-Based Fault Localization for Pharo.  
Given methods and tests, PhaultLoc determines for each method statement whether it was executed by each test, and whether the test passed or failed.
Each method statement is thus associated with each test in one of four categories:
- Executing Passed Tests
- Executing Failed Tests
- Non-Executing Passed Tests
- Non-Executing Failed Tests

This categorization helps identify which statements are potentially faulty based on their execution patterns and test results. 
This enables the calculation of statement coverage metrics such as [Ochiai](https://doi.org/10.1109/TAIC.PART.2007.13) and [Tarantula](https://doi.org/10.1145/581396.581397), which assign a *suspiciousness* score to a statement.
The more suspicious a statement is, the more likely it is to be the cause of a failed test.

```st
coverage := PLStatementCoverage statementCoverageOfMethods: MyClass methods withTests: MyClassTest suite tests.
ochiai := PLStatementCoverage sortByTarantulaScore: coverage.
tarantula := PLStatementCoverage sortByOchiaiScore: coverage.
```

> [!NOTE]
> The tests are expected to be given as a list of `TestCase` instances.

> [!WARNING]
> All tests are executed as many times as there are methods.
> This is due to the current implementation of statement coverage, which only informs whether a statement has been executed or not.

## Installing
```st
Metacello new
  githubUser: 'Gabriel-Darbord' project: 'PhaultLoc' commitish: 'main' path: 'src';
  baseline: 'PhaultLoc';
  load
```
