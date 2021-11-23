unit TournamentManagerTest;

interface
uses
  DUnitX.TestFramework, tmUtils15;

type

  [TestFixture]
  TTournamentManagerTests = class(TObject)
  public
  end;

implementation


initialization
  TDUnitX.RegisterTestFixture(TTournamentManagerTests);
end.

