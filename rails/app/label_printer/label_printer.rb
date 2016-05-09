module LabelPrinter

  Fixnum.send(:include, LabelPrinter::CoreExtensions::Fixnum)
  Float.send(:include, LabelPrinter::CoreExtensions::Float)

end