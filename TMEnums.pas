unit TMEnums;

interface

type

  TCategorysStatus = (csInactive,csPrepared,csGroup,csDraw,csInProgress,csOver);
  TQualificationGroupStatus = (qgsInactive, qgsValidated, qgsGamesAreCreated, qgsInProgress, qgsOver);
  TGameStatus = (gsInactive,gsInProgress,gsOver);
  TPlayAreaStatus = (pasInactive,pasAvailable,pasBusy);
  TRegistrationStatus = (rsDisqualified,rsQualified,rsWO);
  TFirstRoundMode = (frKO,frQualification);
  TWOResult = (woNull,woLose,woWin);
  TScoreMethod = (smGames,smSets);
  TAreaContentType = (actKo, actGroup);

implementation

end.

