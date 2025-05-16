forward
global type nvo_barcodeservice from nonvisualobject
end type
end forward

global type nvo_barcodeservice from nonvisualobject
end type
global nvo_barcodeservice nvo_barcodeservice

type variables
        // Resumen:
        //     Code 39 1D format.
CONSTANT Integer  CODE_39 =3
        // Resumen:
        //     QR Code 2D barcode format.
CONSTANT Integer  QR_CODE = 12
 
end variables

forward prototypes
public function string of_barcodereader (string as_ruta)
public function string of_qrgenerate (string as_data)
public function boolean of_controles_previos ()
end prototypes

public function string of_barcodereader (string as_ruta);integer li_posBarra, li_posPunto, li_largo
String ls_lectura, ls_file
nvo_rsrbarcode ln_rsr

li_posBarra=lastpos(as_ruta, "\") 
li_posPunto=pos(as_ruta, ".", li_posBarra)
li_largo=len(as_ruta)

ls_file = mid(as_ruta, li_posBarra +1 , len(as_ruta) - li_posBarra)

if ls_file = "" then
	messagebox("Error", "¡ Tiene que pasar la ruta completa del PDF !", stopsign!)
	Return ls_lectura
end if	
			
if right(lower(ls_file), 4) <> ".pdf" then
	messagebox("Error",  "¡ El Archivo "+ls_file+ " no es un PDF !", stopsign!)
	Return ls_lectura
end if	

if not of_controles_previos() then
	Return ls_lectura
end if	

ln_rsr = CREATE nvo_rsrbarcode

ls_lectura = ln_rsr.of_ReadBarCodePDF(as_ruta)

//Checks the result
IF  ln_rsr.il_ErrorType < 0 THEN
  messagebox("Failed",  ln_rsr.is_ErrorText, stopsign!)
  RETURN ""
END IF

IF isnull(ls_lectura) THEN ls_lectura=""

DESTROY ln_rsr
RETURN ls_lectura

end function

public function string of_qrgenerate (string as_data);String ls_path
String ls_qr, ls_qr_blanco
String ls_result
nvo_rsrbarcode ln_rsr

if not of_controles_previos() then
	Return ls_qr_blanco
end if	

if isnull(as_data) OR as_data = "" then
	messagebox("Atención!", "¡ No hay Información para generar QR !", exclamation!)
	Return ""
end if

ls_path = GetCurrentDirectory()
CreateDirectory(ls_path + "\QR_IMAGEN")

ls_qr = ls_path + "\QR_IMAGEN\qr.png" // Fichero donde se genera el código de barras

FileDelete(ls_qr) //Si existe lo borro

ln_rsr = CREATE nvo_rsrbarcode

ln_rsr.of_qrgenerate(as_data, ls_qr)

//Checks the result
IF  ln_rsr.il_ErrorType < 0 THEN
  messagebox("Failed",  ln_rsr.is_ErrorText, stopsign!)
END IF
	

IF	NOT FileExists(ls_qr) THEN
	ls_qr =  ls_qr_blanco
END IF

DESTROY ln_rsr

RETURN ls_qr



end function

public function boolean of_controles_previos ();String ls_archivos[]
Int li_idx, li_totalArchivos

ls_archivos[]={"RSRBarcode.deps.json", "RSRBarcode.dll", "zxing.dll", "ZXing.Windows.Compatibility.dll", "PdfiumViewer.dll", "System.Drawing.Common.dll", "Microsoft.Win32.SystemEvents.dll","x64\pdfium.dll" ,"nl\PdfiumViewer.resources.dll"}

li_totalArchivos = UpperBound(ls_archivos[])

FOR li_idx = 1 TO li_totalArchivos
	IF NOT FileExists(gs_appdir+"\DotNet\RSRBarcode\"+ls_archivos[li_idx]) THEN
		messagebox ("Atención", "¡ Necesita el Archivo "+gs_appdir+"\bin\"+ls_archivos[li_idx]+" !", Exclamation!)
		Return FALSE
	END IF
NEXT	


end function

on nvo_barcodeservice.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_barcodeservice.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

