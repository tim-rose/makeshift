#
# ABC.MK --Rules for working with ABC files.
#
# Contents:
#

# 
# %pdf: --Build a printable document from an abc file.
#
%.pdf: %.abc
	abcm2ps $(ABC_FLAGS) -O $*.ps $*.abc
	pstopdf $*.ps && rm $*.ps
#
# %-8va: --Shift by octaves
#
%+8va.abc: %.abc;	  abc2abc $*.abc -t +12 > $@
%-8va.abc: %.abc;	  abc2abc $*.abc -t -12 > $@

clean:	; 	$(RM) *.pdf *.ps
src:	;	mk-filelist -n ABC_SRC *.abc

#
# %-Db.abc: --Transposition rules.
#
%-Db.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for Db instrument)/'; \
	  abc2abc $*.abc -t -1; } > $@

%-D.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for D instrument)/'; \
	  abc2abc $*.abc -t -2; } > $@

%-Eb.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for Eb instrument)/'; \
	  abc2abc $*.abc -t -3; } > $@

%-E.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for E instrument)/'; \
	  abc2abc $*.abc -t -4; } > $@

%-F.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for F instrument)/'; \
	  abc2abc $*.abc -t -5; } > $@

%-F+.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for F# instrument)/'; \
	  abc2abc $*.abc -t +6; } > $@

%-G.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for G instrument)/'; \
	  abc2abc $*.abc -t +5; } > $@

%-Ab.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for Ab instrument)/'; \
	  abc2abc $*.abc -t +4; } > $@

%-A.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for A instrument)/'; \
	  abc2abc $*.abc -t +3; } > $@

%-Bb.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for Bb instrument)/'; \
	  abc2abc $*.abc -t +2; } > $@

%-B.abc: %.abc
	{ echo '$*'| sed -e 's/-/ /g' -e 's/.*/%%header & (transposed for B instrument)/'; \
	  abc2abc $*.abc -t +1; } > $@

