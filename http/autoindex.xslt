<?xml version="1.0" encoding="UTF-8"?>
  <!-- vi: set ft=xml :-->
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes" />
    <xsl:template match="/">
    <html lang="en">
      <head>
        <title>files.clifford.lol</title>
        <link rel="icon" type="image/png" href="https://tim.clifford.lol/avatar_48.png"/>
        <meta charSet="utf-8"/>
        <meta content="width=device-width, initial-scale=1" name="viewport"/>
        <link rel="stylesheet" href="https://tim.clifford.lol/main.css"/>
      </head>
      <body>
        <div class="purple outer-flex">
          <div class="Topbar_div">
            <nav class="Topbar_nav">
              <div class="topbar-title" style="display:flex; flex-direction: row">
                <a href="/">
                  <img class="topbar-img" src="https://tim.clifford.lol/avatar_128.png"/>
                </a>
                <div style="font-size: 18px; margin: 12px; align-self: center;">
                  files.clifford.lol
                </div>
              </div>
              <ul>
                <li>
                  <a href="https://tim.clifford.lol/"
                     class="Topbar_bigbutton">Main site
                  </a>
                </li>
              </ul>
            </nav>
          </div>
          <div class="single">
            <div class="wrap">
              <div class="page">
                <table>
                  <tr>
                      <th>name</th>
                      <th>size</th>
                  </tr>
                  <xsl:for-each select="list/*">
                    <xsl:variable name="name">
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:variable name="size">
                      <xsl:if test="string-length(@size) &gt; 0">
                        <xsl:if test="number(@size) &gt; 0">
                          <xsl:choose>
                            <xsl:when test="round(@size div 1024) &lt; 1"><xsl:value-of select="@size" /></xsl:when>
                            <xsl:when test="round(@size div 1048576) &lt; 1"><xsl:value-of select="format-number((@size div 1024), '0.0')" />K</xsl:when>
                            <xsl:otherwise><xsl:value-of select="format-number((@size div 1048576), '0.00')" />M</xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                      </xsl:if>
                    </xsl:variable>
                    <tr>
                      <td><a href="{$name}"><xsl:value-of select="."/></a></td>
                      <td align="right"><xsl:value-of select="$size"/></td>
                    </tr>
                  </xsl:for-each>
                </table>
              </div>
            </div>
          </div>
          <div style="background:#20222b;padding:60px 0">
            <p class="credits">
              The design is from
              <a class="cyan" href="https://draculatheme.com" target="blank">
                draculatheme.com
              </a>,
              <br/>
              made with <span class="love">♥</span> by
              <a class="green" href="https://zenorocha.com" target="blank">
                Zeno Rocha
              </a>
              <br/>
                under
              <a class="orange" href="http://zenorocha.mit-license.org/" target="blank">
                MIT license
              </a>
            </p>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
