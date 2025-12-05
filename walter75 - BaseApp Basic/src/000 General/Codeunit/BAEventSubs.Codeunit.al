codeunit 80036 "SEW BA Event Subs"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", OnCompanyOpenCompleted, '', false, false)]
    local procedure OnCompanyOpenCompleted()
    var
        SEWPKSingleInstance: Codeunit "SEW BA Single Instance";
    begin
        // Just to ensure that the SingleInstance codeunit is loaded
        if (CurrentClientType() in [CurrentClientType::Web, CurrentClientType::Phone, CurrentClientType::Tablet, CurrentClientType::Teams, CurrentClientType::Desktop]) then
            if not SEWPKSingleInstance.GetInitialized() then
                SEWPKSingleInstance.SetInitialized();
    end;
}