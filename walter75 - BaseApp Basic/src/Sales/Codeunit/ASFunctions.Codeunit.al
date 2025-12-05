codeunit 80038 "SEW AS Functions"
{
    Permissions = tabledata "Comment Line" = r;

    procedure GetCustomerComment(CustomerNo: Code[20]): Text
    var
        CommentLine: Record "Comment Line";
        xComment: Text;
    begin
        Clear(xComment);

        CommentLine.Reset();
        CommentLine.SetRange("Table Name", "Comment Line Table Name"::Customer);
        CommentLine.SetRange("No.", CustomerNo);
        if CommentLine.FindSet() then
            repeat
                if CommentLine."Date" <> 0D then
                    xComment := xComment + '\\>>>>>> ' + Format(CommentLine."Date") + ' <<<<<';

                xComment := xComment + '\' + CommentLine.Comment;
            until CommentLine.Next() = 0;

        exit(xComment);
    end;
}