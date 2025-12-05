codeunit 80000 "SEW BA Single Instance"
{
    SingleInstance = true;
    Permissions = tabledata "Customer" = rmid;


    #region Sales Functions
    procedure SetAutoExplode(xMode: Boolean)
    begin
        SEWAutoExplode := xMode
    end;

    procedure GetAutoExplode(): Boolean
    begin
        exit(SEWAutoExplode);
    end;
    #endregion


    #region General Functions
    procedure SetInitialized()
    begin
        initialized := true;
    end;

    procedure GetInitialized(): Boolean
    begin
        exit(initialized);
    end;
    #endregion


    #region Variables
    var
        initialized: Boolean;
        SEWAutoExplode: Boolean;

    #endregion

}
