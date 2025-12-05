pageextension 80054 "SEW RE Company Information" extends "Company Information"
{
    layout
    {

        addbefore(Picture)
        {
            field("SEW Managing Director"; Rec."SEW Managing Director")
            {
                ApplicationArea = All;
            }
            field("SEW Commercial Register"; Rec."SEW Commercial Register")
            {
                ApplicationArea = All;
            }
            field("SEW Conditions URL"; Rec."SEW Conditions URL")
            {
                ApplicationArea = All;
            }
            field("SEW Data Protection URL"; Rec."SEW Data Protection URL")
            {
                ApplicationArea = All;
            }
        }


        addafter("Payments")
        {
            group("SEW addBankAccounts")
            {
                Caption = 'additional Bank Accounts';
                field("SEW Bank Name 02"; Rec."SEW Bank Name 02")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank Account No. 02"; Rec."SEW Bank Account No. 02")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank Branch No. 02"; Rec."SEW Bank Branch No. 02")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank IBAN 02"; Rec."SEW Bank IBAN 02")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank SWIFT Code 02"; Rec."SEW Bank SWIFT Code 02")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank Name 03"; Rec."SEW Bank Name 03")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank Account No. 03"; Rec."SEW Bank Account No. 03")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank Branch No. 03"; Rec."SEW Bank Branch No. 03")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank IBAN 03"; Rec."SEW Bank IBAN 03")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Bank SWIFT Code 03"; Rec."SEW Bank SWIFT Code 03")
                {
                    ApplicationArea = Basic, Suite;
                }

            }
        }
        addafter("Tax Office")
        {
            group("SEW DocumentText")
            {
                Caption = 'Document Texts';
                field("SEW Document Text 01"; Rec."SEW Document Text 01")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Text 02"; Rec."SEW Document Text 02")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Text 03"; Rec."SEW Document Text 03")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Text 04"; Rec."SEW Document Text 04")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Text 05"; Rec."SEW Document Text 05")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Text 06"; Rec."SEW Document Text 06")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("SEW DocumentFooterText")
            {
                Caption = 'Document Footer Texts';
                field("SEW Document Footer Text 01"; Rec."SEW Document Footer Text 01")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Footer Text 02"; Rec."SEW Document Footer Text 02")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Footer Text 03"; Rec."SEW Document Footer Text 03")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Footer Text 04"; Rec."SEW Document Footer Text 04")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Footer Text 05"; Rec."SEW Document Footer Text 05")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Document Footer Text 06"; Rec."SEW Document Footer Text 06")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group("SEW DocumentImage")
            {
                Caption = 'Document Images';
#pragma warning disable AW0009
                field("SEW Picture 2"; Rec."SEW Picture 2")
#pragma warning restore AW0009
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
#pragma warning disable AW0009
                field("SEW Picture 3"; Rec."SEW Picture 3")
#pragma warning restore AW0009
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
#pragma warning disable AW0009
                field("SEW Picture 4"; Rec."SEW Picture 4")
#pragma warning restore AW0009
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
#pragma warning disable AW0009
                field("SEW Picture 5"; Rec."SEW Picture 5")
#pragma warning restore AW0009
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
            }
            group("SEW Company CI")
            {
                Caption = 'Company Corporate Identity';
                field("SEW Company Color 1"; Rec."SEW Company Color 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Company Font Color 1"; Rec."SEW Company Font Color 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Company Font 1"; Rec."SEW Company Font 1")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Company Color 2"; Rec."SEW Company Color 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Company Font Color 2"; Rec."SEW Company Font Color 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("SEW Company Font 2"; Rec."SEW Company Font 2")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("SEW ClearImage2")
            {
                ApplicationArea = All;
                Caption = 'Clear Image 2';
                ToolTip = 'Clear Image 2.';
                Image = Picture;

                trigger OnAction()
                begin
                    Clear(Rec."SEW Picture 2");
                    Rec.Modify(false);
                end;
            }
            action("SEW ClearImage3")
            {
                ApplicationArea = All;
                Caption = 'Clear Image 3';
                ToolTip = 'Clear Image 3.';
                Image = Picture;

                trigger OnAction()
                begin
                    Clear(Rec."SEW Picture 3");
                    Rec.Modify(false);
                end;
            }
            action("SEW ClearImage4")
            {
                ApplicationArea = All;
                Caption = 'Clear Image 4';
                ToolTip = 'Clear Image 4.';
                Image = Picture;

                trigger OnAction()
                begin
                    Clear(Rec."SEW Picture 4");
                    Rec.Modify(false);
                end;
            }
            action("SEW ClearImage5")
            {
                ApplicationArea = All;
                Caption = 'Clear Image 5';
                ToolTip = 'Clear Image 5.';
                Image = Picture;

                trigger OnAction()
                begin
                    Clear(Rec."SEW Picture 5");
                    Rec.Modify(false);
                end;
            }
        }

    }
}
