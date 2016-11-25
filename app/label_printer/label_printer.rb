module LabelPrinter
  DEFAULT_ENCODING = Encoding::CP850

  Fixnum.send(:include, LabelPrinter::CoreExtensions::Fixnum)
  Float.send(:include, LabelPrinter::CoreExtensions::Float)

end