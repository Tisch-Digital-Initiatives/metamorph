from saxonche import PySaxonProcessor


class Xmldoc():
    _root = None
    _xpathproc = None
    _xsltproc = None
    insert = """<?xml version="1.0" encoding="UTF-8"?>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
            xmlns:tufts="http://dl.tufts.edu/terms#">
            <!-- Identity transform -->
            <xsl:template match="@* | node()">
            <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:template>
            <xsl:template match="MATCHPOINT">
                <xsl:copy-of select="."/>
                NEW_ELEMENT
            </xsl:template>
        </xsl:stylesheet>
        """
    
    def __init__(self, file_or_buffer):
        with PySaxonProcessor(license=False) as proc:
            if file_or_buffer.startswith('<?xml'):
                self._root = proc.parse_xml(xml_text=file_or_buffer)
            else:
                self._root = proc.parse_xml(xml_file_name=file_or_buffer)
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
    
    def insert_element(self, matchpoint, element):
        xslt_string = self.insert.replace('MATCHPOINT', matchpoint)
        xslt_string = xslt_string.replace('NEW_ELEMENT', element)
        return self.apply_xslt(xslt_string)

    def replace_element(self, matchpoint, element):
        xslt_string = self.insert.replace('MATCHPOINT', matchpoint)
        xslt_string = xslt_string.replace('NEW_ELEMENT', element)
        xslt_string = xslt_string.replace('<xsl:copy-of select="."/>', '')
        return self.apply_xslt(xslt_string)
    
    def apply_xslt(self, xslt):
        if xslt.startswith('<?xml'):
            xexec = self._xsltproc.compile_stylesheet(stylesheet_text=xslt)
        else:
            xexec = self._xsltproc.compile_stylesheet(stylesheet_file=xslt)
        return xexec.transform_to_string(xdm_node=self._root)