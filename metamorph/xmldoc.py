from saxonche import PySaxonProcessor


class Xmldoc():
    _root = None
    _xpathproc = None
    _xsltproc = None
    
    def __init__(self, file_or_buffer):
        with PySaxonProcessor(license=False) as proc:
            self._root = proc.parse_xml(xml_text=file_or_buffer)
            self._xpathproc = proc.new_xpath_processor()
            self._xsltproc = proc.new_xslt30_processor()
    
    def xpath_to_nodes(self, xpath, context=None):
        if not context:
            context = self._root
        self._xpathproc.set_context(xdm_item=context)
        return self._xpathproc.evaluate(xpath)
    
    def xpath_to_stringlist(self, xpath, context=None):
        nodes = self.xpath_to_nodes(xpath, context)
        strings = []
        if nodes:
            for i in nodes:
                strings.append(i.string_value)
        return strings
    
    def xpath_to_string(self, xpath, sep=', ', context=None):
        strings = self.xpath_to_stringlist(xpath, context)
        return sep.join(strings)
    
    def set_namespaces(self, namespaces):
        for i in namespaces.keys():
            self._xpathproc.declare_namespace(i, namespaces[i])
    
    def apply_xslt(self, xslt):
        xexec = self._xsltproc.compile_stylesheet(stylesheet_file=xslt)
        return xexec.transform_to_string(xdm_node=self._root)