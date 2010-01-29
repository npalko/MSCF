from pyPdf import PdfFileWriter, PdfFileReader




notesFile = 'Lectures.pdf'
blankFile = 'Blank.pdf'
outFile = 'Modified Lectures.pdf'

output = PdfFileWriter()
notes = PdfFileReader(file(notesFile, 'rb'))
blank = PdfFileReader(file(blankFile, 'rb'))

for i in xtrange(notes.getNumPages()):
    output.addPage(notes.getPage(i))
    output.addPage(blank.getPage(0))

outStream = file(outFile, 'wb')
output.write(outStream)
outStream.close()
