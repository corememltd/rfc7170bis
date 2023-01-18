DRAFT	:= draft-ietf-emu-rfc7170bis
VERSION	:= $(shell sed -n -e'/docname/s,.*[^0-9]*-\([0-9]*\).*,\1,p' ${DRAFT}.md )
EXAMPLES =

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	@cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt

#	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

%.xml: %.md ${EXAMPLES}
	@kramdown-rfc2629 -3 ${DRAFT}.md > ${DRAFT}.xml
	@xml2rfc --v2v3 ${DRAFT}.xml
	@mv ${DRAFT}.v2v3.xml ${DRAFT}.xml

%.txt: %.xml
	@xml2rfc --text -o $@ $?

%.html: %.xml
	@xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	@curl -S -F "user=aland@freeradius.org" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submit

.PHONY:
version:
	@echo Version: ${VERSION}

.PHONY:
clean:
	@rm -f *.xml *~

.PHONY: tag
tag:
	@git tag ${DRAFT}-${VERSION}

.PRECIOUS: ${DRAFT}.xml
