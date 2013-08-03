#
# H/Direct specific paths and settings.
#
# Currently just controlling the invocation of
# of ihc/hdirect itself.
#


IHC_OPTS = $(SRC_IHC_OPTS) $(WAY$(_way)_IHC_OPTS) $($*_IHC_OPTS) $(EXTRA_IHC_OPTS)

ifeq "$(STANDALONE_DIST)" "YES"
HC_OPTS            = $(SRC_HC_OPTS) $(WAY$(_way)_HC_OPTS) $($*_HC_OPTS) $(EXTRA_HC_OPTS)
AR_OPTS            = $(SRC_AR_OPTS) $(WAY$(_way)_AR_OPTS) $(EXTRA_AR_OPTS)
CPP_OPTS           = $(SRC_CPP_OPTS) $(WAY$(_way)_CPP_OPTS) $(EXTRA_CPP_OPTS)
CC_OPTS            = $(SRC_CC_OPTS) $(WAY$(_way)_CC_OPTS) $($*_CC_OPTS) $(EXTRA_CC_OPTS)
HAPPY_OPTS         = $(SRC_HAPPY_OPTS) $(WAY$(_way)_HAPPY_OPTS) $($*_HAPPY_OPTS) $(EXTRA_HAPPY_OPTS)
GREENCARD_OPTS     = $(SRC_GREENCARD_OPTS) $(WAY$(_way)_GREENCARD_OPTS) $($*_GREENCARD_OPTS) $(EXTRA_GREENCARD_OPTS)
INSTALL_OPTS       = $(SRC_INSTALL_OPTS) $(WAY$(_way)_INSTALL_OPTS) $(EXTRA_INSTALL_OPTS)
INSTALL_BIN_OPTS   = $(INSTALL_OPTS) $(SRC_INSTALL_BIN_OPTS)
LD_OPTS            = $(SRC_LD_OPTS) $(WAY$(_way)_LD_OPTS) $(EXTRA_LD_OPTS)
MKDEPENDC_OPTS     = $(SRC_MKDEPENDC_OPTS) $(WAY$(_way)_MKDEPENDC_OPTS) $(EXTRA_MKDEPENDC_OPTS)
MKDEPENDHS_OPTS    = $(SRC_MKDEPENDHS_OPTS) $(WAY$(_way)_MKDEPENDHS_OPTS) \
                     $(EXTRA_MKDEPENDHS_OPTS)
ZIP_OPTS           = $(SRC_ZIP_OPTS) $(EXTRA_ZIP_OPTS)
SRC_AR_OPTS += clqs

endif

SGML2LATEX_OPTS    = $(SRC_SGML2LATEX_OPTS) $(WAY$(_way)_SGML2LATEX_OPTS) $(EXTRA_SGML2LATEX_OPTS)
SGML2INFO_OPTS     = $(SRC_SGML2INFO_OPTS) $(WAY$(_way)_SGML2INFO_OPTS) $(EXTRA_INFO_OPTS)
SGML2TXT_OPTS      = $(SRC_SGML2TXT_OPTS) $(WAY$(_way)_SGML2TXT_OPTS) $(EXTRA_SGML2TXT_OPTS)
SGML2HTML_OPTS     = $(SRC_SGML2HTML_OPTS) $(WAY$(_way)_SGML2HTML_OPTS) $(EXTRA_SGML2HTML_OPTS)

