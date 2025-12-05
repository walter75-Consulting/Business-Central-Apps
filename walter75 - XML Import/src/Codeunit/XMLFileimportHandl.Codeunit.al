codeunit 60500 "SEW XML Fileimport Handl"
{
    procedure ParseXmlText(var XmlText: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        xmlDoc: XmlDocument;
        specialCharInt: Integer;
        specialChar: Char;
        Xml_outstream: OutStream;
        Xml_instream: InStream;
    begin
        //Sämtliche nicht druckbare Steuerzeichen entfernen
        for specialCharInt := 0 to 31 do begin
            specialChar := specialCharInt;
            XmlText := DelChr(XmlText, '=', specialChar);
        end;
        specialChar := 127;
        XmlText := DelChr(XmlText, '=', specialChar);
        //XmlText := XmlText.Replace(Format(0), '');

        //kaufmännisches Und ersetzen
        //XmlText := XmlText.replace('&', '&amp;');

        TempBlob.CreateOutStream(Xml_outstream, TextEncoding::UTF8);
        Xml_outstream.WriteText(XmlText);
        TempBlob.CreateInStream(Xml_instream, TextEncoding::UTF8);

        //Prüfen ob gültiges Xml
        XmlDocument.ReadFrom(Xml_instream, xmlDoc);
    end;
}