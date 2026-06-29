# qrcode_pdf — Leer y escribir códigos QR dentro de PDFs con PowerBuilder 📄🔳

![PowerBuilder](https://img.shields.io/badge/PowerBuilder-2025-2D6CDF?style=flat-square)
![.NET](https://img.shields.io/badge/.NET-10-512BD4?style=flat-square&logo=dotnet&logoColor=white)
![ZXing](https://img.shields.io/badge/QR-ZXing.Net-00A98F?style=flat-square)
![PDFtoImage](https://img.shields.io/badge/PDF-PDFtoImage-1f6feb?style=flat-square)
![Blog](https://img.shields.io/badge/blog-rsrsystem-FF5722?style=flat-square&logo=blogger&logoColor=white)

## 📋 ¿Qué es esto?

Un ejemplo PowerBuilder para **leer y escribir códigos QR directamente en documentos PDF**. La
idea es muy de andar por casa pero tremendamente útil: cogéis vuestros albaranes en PDF, les
**incrustáis un QR** con su identificador, y luego sois capaces de **leer ese QR de vuelta sin sacar
el PDF a imagen vosotros** ni andar con capturas de pantalla.

Para el ejemplo he generado unos albaranes (*Delivery Note*) con el formato
`company-year-series-delivery_note`. Por ejemplo `1-2023-1-17629` (company=1, year=2023, series=1,
delivery_note=17629). Tenéis dos pantallas:

- **Lector** (`qr_pdfreader`): metéis los PDFs en la carpeta `pdf` y la app os **lee el QR** que
  llevan dentro. He puesto un botón que carga de golpe todos los de una carpeta en el DataWindow,
  en vez de ir uno a uno.
- **Escritor** (`qr_pdfwriter`): coge los documentos de la carpeta `pdfwriter`, les **incrusta el
  QR** y guarda el resultado en la misma carpeta del original, con el nº de fila del DataWindow
  como nombre.

¿Y cómo lo hace PowerBuilder, que él solito no sabe ni leer un PDF ni decodificar un QR? Pues
**apoyándose en .NET**. Cargamos una librería .NET (`RSRBarcode`) como `dotnetobject` con el **.NET
DLL Importer** de PB. Eso nos genera un objeto proxy que desde PowerScript usamos como si fuera
nativo. Fijaos en lo cómodo que queda:

- **Leer un QR de un PDF** → `ReadBarcodePDF(rutaPdf)`. La librería **rasteriza la página** del PDF
  a imagen por dentro y decodifica el código. PowerBuilder solo le pasa la ruta del PDF y recibe el
  texto del QR. Sin pasos intermedios.
- **Generar el QR** → `QrGenerate(texto, ficheroPng)` crea la imagen del QR que luego se incrusta
  en el documento.

## 🔗 Motor .NET

El trabajo de verdad lo hace la librería .NET **`RSRBarcode`** (clase `RSRbarcode`), el "todo en
uno" de códigos de barras de la casa:

- Se **despliega** ya compilada en la carpeta `DotNet\RSRBarcode\` de este propio ejemplo, para que
  clones, compiles y funcione sin tocar nada más.
- Se **consume** desde PowerBuilder como `dotnetobject` (proxy creado con el .NET DLL Importer).
- El **código fuente** vive en `Blog\Net10\RSRBarcode` (antes estaba en `Net8`) y se
  recompila/despliega con el script **`desplegar_dotnet.bat`** (hace `dotnet publish` y espeja las
  DLLs a la carpeta `DotNet` de cada ejemplo).
- Repo del proyecto .NET (Visual Studio 2022): <https://github.com/rasanfe/RSRBarcode>

> 🆕 **Nota didáctica (migración a .NET 10):** `RSRBarcode` dejó atrás el **abandonado PdfiumViewer
> (2018)** y ahora rasteriza el PDF con **[PDFtoImage](https://www.nuget.org/packages/PDFtoImage)**
> (MIT, PDFium + SkiaSharp). Además, la lectura/generación del código pasó al **binding SkiaSharp de
> ZXing** (`ZXing.Net.Bindings.SkiaSharp`) en lugar de la antigua compatibilidad con `System.Drawing`.
> Si recompiláis la DLL, acordaos de **volver a desplegarla**.

## 🛠️ Requisitos

- **PowerBuilder 2025** para abrir y compilar la solución.
- **.NET 10 Runtime** instalado en la máquina → <https://dotnet.microsoft.com/en-us/download/dotnet/10.0>
- La carpeta `DotNet\RSRBarcode\` con las DLLs desplegadas (ya viene en el repo).

## ▶️ Cómo probarlo

1. Clona el repo y abre `qrcode_pdf.pbsln` con PowerBuilder 2025.
2. Compila (Full Build) y ejecuta.
3. **Para leer:** deja unos PDFs con QR en la carpeta `pdf`, pulsa el botón de carga y verás cómo
   la app lee el contenido del QR de cada documento.
4. **Para escribir:** deja los documentos en `pdfwriter`, genera los QR y mira el PDF resultante
   con el código ya incrustado.

## 🔗 Repo PowerBuilder

<https://github.com/rasanfe/qrcode_pdf>

---

> ¡Nos vemos en el próximo artículo! Y recuerda: en PowerBuilder, los límites solo están en nuestra imaginación. 🚀

📨 **Blog:** <https://rsrsystem.blogspot.com/>
