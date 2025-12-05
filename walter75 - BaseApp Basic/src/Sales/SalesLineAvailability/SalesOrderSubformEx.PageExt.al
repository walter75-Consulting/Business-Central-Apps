/// <summary>
/// Beispiel PageExtension für Sales Order Subform
/// Zeigt die Verwendung der Sales Line Availability Management Codeunit
/// zur farbigen Markierung von Verkaufszeilen basierend auf Bestandsprüfungen
/// 
/// VERWENDUNGSHINWEISE:
/// 1. Diese Extension duplizieren und Object-IDs anpassen
/// 2. Bei Bedarf zusätzliche Felder einblenden/ausblenden
/// 3. CalcLineStyle() kann auch für Sales Quote Subform verwendet werden
/// </summary>
pageextension 80070 "SEW Sales Order Subform Ex" extends "Sales Order Subform"
{
    layout
    {
        // Beispiel: Style auf vorhandene Felder anwenden
        modify("No.")
        {
            StyleExpr = StyleText;
        }
        modify(Type)
        {
            StyleExpr = StyleText;
        }
        modify(Description)
        {
            StyleExpr = StyleText;
        }
        modify("Description 2")
        {
            StyleExpr = StyleText;
        }
        modify(Quantity)
        {
            StyleExpr = StyleText;

            trigger OnAfterValidate()
            begin
                // Nach Mengeneingabe sofort Style neu berechnen
                UpdateLineStyle();
            end;
        }
    }

    var
        SEWSalesLineAvailMgt: Codeunit "SEW Sales Line Avail Mgt.";
        StyleText: Text;

    trigger OnAfterGetRecord()
    begin
        UpdateLineStyle();
    end;

    local procedure UpdateLineStyle()
    begin
        // StyleText für die aktuelle Zeile berechnen
        StyleText := SEWSalesLineAvailMgt.CalcLineStyle(Rec);
    end;
}
