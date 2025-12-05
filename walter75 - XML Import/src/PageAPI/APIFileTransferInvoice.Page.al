// page 60507 "SEW API FileTransfer Invoice"
// {
//     PageType = API;
//     Caption = 'FileTransfer';
//     APIPublisher = 'kastenmueller';
//     APIGroup = 'jacob';
//     APIVersion = 'beta', 'v1.0';
//     EntityName = 'fileTransferInvoice';
//     EntitySetName = 'fileTransferInvoices';
//     SourceTable = "SEW Filetransfer";
//     DelayedInsert = true;


//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field(transferID; Rec.transferID)
//                 {
//                     Caption = 'transferID';
//                     Editable = false;
//                 }
//                 field(tansferDateTime; Rec."Transfer Date/Time")
//                 {
//                     Caption = 'transferDateTime';
//                     Editable = false;
//                 }
//                 field(fileContentBlob; FileContentText)
//                 {
//                     Caption = 'FileContentBlob';
//                     trigger OnValidate()
//                     var
//                         FileTransferHandling: Codeunit "SEW Filetransfer Handling";
//                     begin
//                         FileTransferHandling.ParseXmlText(FileContentText);
//                         Rec.Init();
//                         Rec."Doc Typ" := "SEW Transfer Type"::Invoice;
//                         Rec.Insert(true);
//                         Commit(); // we need to commit here, otherwise the blob is not saved correctly
//                         Rec.SaveFileContent(FileContentText);
//                     end;
//                 }
//                 field(id; Rec.SystemId)
//                 {
//                     Caption = 'systemId';
//                     Editable = false;
//                 }
//                 field(lastModifiedDateTime; Rec.SystemModifiedAt)
//                 {
//                     Caption = 'lastModifiedDateTime';
//                     Editable = false;
//                 }
//             }
//         }
//     }


//     trigger OnAfterGetCurrRecord()
//     begin
//         FileContentText := Rec.GetFileContent()
//     end;



//     var
//         FileContentText: Text;
// }