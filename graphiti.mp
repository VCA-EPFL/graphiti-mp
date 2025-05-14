if known graphiti_mp_header:
  message "graphiti was loaded twice";
  expandafter endinput
fi
string graphiti_mp_header;
graphiti_mp_header := "";

input boxes;

newinternal graphdefaultdx, graphdefaultdy;
graphdefaultdx := graphdefaultdy := 3bp;
newinternal sz; sz := .1cm;
newinternal dist; dist := .5cm;
newinternal u; u := 1cm;
newinternal connectdist; connectdist := .5dist - sz - 1pt;

vardef lght(expr c) =
  .25[c, white]
enddef;

vardef drk(expr c) =
  .25[c, black]
enddef;

def forkpath_(suffix $) =
  $.nw -- $.ne -- ($.se + ($.dist, 0)) -- ($.sw - ($.dist, 0)) -- cycle
enddef;

vardef createFlexBranch(suffix s) (expr pic, coll) =
  boxit.s(pic);

  pair s.in; s.in = .5[s.nw, s.ne] + (0, sz);
  pair s.out[];
  s.out0 = .27[(s.sw - (s.dist, 0)), (s.se + (s.dist, 0))] - (0, sz);
  s.out1 = .73[(s.sw - (s.dist, 0)), (s.se + (s.dist, 0))] - (0, sz);
  pair s.cond; s.cond = .5[(s.se + (s.dist, 0)), s.ne] + (sz, 0);
  pair s.icond; s.icond = .5[(s.sw - (s.dist, 0)), s.nw] - (sz, 0);
  s.dist = 5;

  string s.drawp_; string s.fillp_; s.drawp_ := s.fillp_ := "forkpath_";

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

vardef mergepath_(suffix $) =
  $.sw -- $.se -- ($.ne + ($.dist, 0)) -- ($.nw - ($.dist, 0)) -- cycle
enddef;

vardef createFlexMerge(suffix s) (expr pic, coll) =
  boxit.s(pic);

  pair s.out; s.out = .5[s.sw, s.se] - (0, sz);
  pair s.in[];
  s.in0 = .27[(s.nw - (s.dist, 0)), (s.ne + (s.dist, 0))] + (0, sz);
  s.in1 = .73[(s.nw - (s.dist, 0)), (s.ne + (s.dist, 0))] + (0, sz);
  pair s.cond; s.cond = .5[s.se, (s.ne + (s.dist, 0))] + (sz, 0);
  pair s.icond; s.icond = .5[s.sw, (s.nw - (s.dist, 0))] - (sz, 0);
  s.dist = 5;

  string s.drawp_; string s.fillp_; s.drawp_ := "mergepath_"; s.fillp_ := "mergepath_";

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

vardef createFork(suffix s) (expr shft, loc, coll) =
  path s; save locals; path locals;
  locals := (0,0) -- (1,0) -- (0.85,0.3) -- (0.15,0.3) -- cycle;
  locals := locals shifted -center locals scaled shft shifted loc;
  s := locals;

  pair s.in; s.in := top top .5[ulcorner s, urcorner s];
  pair s.out[];
  s.out0 := bot bot .27[llcorner s, lrcorner s];
  s.out1 := bot bot .73[llcorner s, lrcorner s];
  pair s.cond; s.cond := rt rt point .5 of subpath(1, 2) of s;

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);

  path s.drawpath_; s.drawpath_ := locals;
enddef;

vardef boxpath_(suffix $) =
  $.sw -- $.se -- $.ne -- $.nw -- cycle
enddef;

vardef createFlexBox(suffix s) (expr pic, dimtop, dimbot, coll) =
  boxit.s(pic);

  pair s.out[];
  pair s.in[];

  for i=0 upto dimbot:
    s.out[i] := ((i + 1)/(dimbot + 1))[s.sw, s.se] - (0, sz);
  endfor;

  for i=0 upto dimtop:
    s.in[i] := ((i + 1)/(dimtop + 1))[s.nw, s.ne] + (0, sz);
  endfor;

  string s.drawp_; string s.fillp_; s.drawp_ := "boxpath_"; s.fillp_ := "boxpath_";

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

vardef oppath_(suffix $) =
  ($.sw -- $.se -- $.ne -- $.nw -- cycle) cornered $.rounded
enddef;

vardef opoverlay_(suffix $) =
  image(draw (.25[$.sw, $.nw] -- .25[$.se, $.ne]); draw (.75[$.sw, $.nw] -- .75[$.se, $.ne]);)
enddef;

vardef createFlexOp(suffix s) (expr pic, dimtop, dimbot, pipelined, coll) =
  boxit.s(pic);

  numeric s.rounded; s.rounded = (ypart (s.nw - s.sw)) / 4;

  pair s.out[];
  pair s.in[];

  for i=0 upto dimbot:
    s.out[i] := ((i + 1)/(dimbot + 1))[s.sw, s.se] - (0, sz);
  endfor;

  for i=0 upto dimtop:
    s.in[i] := ((i + 1)/(dimtop + 1))[s.nw, s.ne] + (0, sz);
  endfor;

  if pipelined > 1:
    string s.drawp_; string s.fillp_; s.drawp_ := "oppath_"; s.fillp_ := "oppath_";
    string s.overlayp_; s.overlayp_ := "opoverlay_";
  else:
    string s.drawp_; string s.fillp_; s.drawp_ := "oppath_"; s.fillp_ := "oppath_";
  fi

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

def createBox(suffix s) (expr dimtop, dimbot, shft, loc, coll) =
  path s;
  s := unitsquare shifted - (center unitsquare);
  s := s xyscaled shft shifted loc;

  pair s.out[];
  pair s.in[];

  for i=0 upto dimbot:
    s.out[i] := bot bot (point ((i + 1)/(dimbot + 1)) of (llcorner s -- lrcorner s));
  endfor;

  for i=0 upto dimtop:
    s.in[i] := top top (point ((i + 1)/(dimtop + 1)) of (ulcorner s -- urcorner s));
  endfor;

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);

  path s.drawpath_; s.drawpath_ := s;
enddef;

def circlepath_(suffix $) = bpath.$ enddef;

vardef createFlexCircle(suffix s) (expr pic, coll) =
  circleit.s(pic);

  pair s.in; s.in = .5[s.nw, s.ne];
  pair s.out[];
  s.out0 = .27[s.sw, s.se];
  s.out1 = .73[s.sw, s.se];
  pair s.cond; s.cond = .5[s.se, s.ne];
  s.dist = 5;

  string s.drawp_; string s.fillp_; s.drawp_ := s.fillp_ := "circlepath_";

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

vardef taggerpath_(suffix $) =
  $.ne -- $.nw -- $.sw -- $.se -- ($.se - (0, ypart $.size_)) -- ($.sw - $.size_) -- ($.nw + (-xpart $.size_, ypart $.size_)) -- ($.ne + (0, ypart $.size_)) -- cycle
enddef;

vardef createFlexTagger(suffix s) (expr pic, size, coll) =
  boxit.s(pic);

  pair s.toplabel; s.toplabel = .5[(s.ne + (0, ypart size)), s.nw];
  pair s.botlabel; s.botlabel = .5[(s.se - (0, ypart size)), s.sw];

  pair s.size_; s.size_ = size;
  pair s.intop; s.intop = .5[s.nw + (0, ypart s.size_), s.ne + (0, ypart s.size_)] + (0, sz);
  pair s.outtop; s.outtop = .5[s.nw, s.ne] - (0, sz);
  pair s.inbot; s.inbot = .5[s.sw, s.se] + (0, sz);
  pair s.outbot; s.outbot = .5[s.sw - (0, ypart s.size_), s.se - (0, ypart s.size_)] - (0, sz);

  string s.drawp_; string s.fillp_; s.drawp_ := "taggerpath_"; s.fillp_ := "taggerpath_";

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

def createTagger(suffix s) (expr innerbox, size, coll) =
  path s;
  s := ;

  pair s.toplabel; s.toplabel := .5[((urcorner innerbox) + (0, ypart size)), ulcorner innerbox];
  pair s.botlabel; s.botlabel := .5[((lrcorner innerbox) - (0, ypart size)), llcorner innerbox];

  pair s.intop; pair s.inbot; pair s.outtop; pair s.outbot;
  s.intop := top top .5[ulcorner innerbox + (0, ypart size), urcorner innerbox + (0, ypart size)];
  s.outtop := bot bot .5[ulcorner innerbox, urcorner innerbox];
  s.inbot := top top .5[llcorner innerbox, lrcorner innerbox];
  s.outbot := bot bot .5[llcorner innerbox - (0, ypart size), lrcorner innerbox - (0, ypart size)];

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);

  path s.drawpath_; s.drawpath_ := s;
enddef;

def qdrawpath_(suffix $) =
  $.ne -- $.nw -- $.sw -- $.se -- ($.se - (0, ypart $.size)) -- ($.sw - $.size) -- ($.nw + (-xpart $.size, ypart $.size)) -- ($.ne + (0, ypart $.size)) -- cycle;
enddef;

def createQ(suffix s) (expr dimtop, dimbot, shft, loc, coll) = 
  path s;
  s := unitsquare shifted - (center unitsquare);
  s := s xyscaled shft shifted loc;
  path s.drawpath_; s.drawpath_ := urcorner s -- lrcorner s -- llcorner s -- ulcorner s -- .7[ulcorner s, llcorner s] -- .7[urcorner s, lrcorner s];

  pair s.out[];
  pair s.in[];

  for i=0 upto dimbot:
    s.out[i] := bot bot (point ((i + 1)/(dimbot + 1)) of (llcorner s -- lrcorner s));
  endfor;

  for i=0 upto dimtop:
    s.in[i] := top top (point ((i + 1)/(dimtop + 1)) of (ulcorner s -- urcorner s));
  endfor;

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

def qdrawpath_(suffix $) = 
  $.nw -- $.sw -- $.se -- $.ne -- .3[$.se, $.ne] -- .3[$.sw, $.nw];
enddef;

def qfillpath_(suffix $) = bpath.$ enddef;

vardef createFlexQ(suffix s) (expr pic, coll) =
  boxit.s(pic);

  pair s.in; s.in = .5[s.nw, s.ne];
  pair s.out[];
  s.out0 = .27[s.sw, s.se];
  s.out1 = .73[s.sw, s.se];
  pair s.cond; s.cond = .5[s.se, s.ne];
  s.dist = 5;

  string s.drawp_; s.drawp_ := "qdrawpath_";
  string s.fillp_; s.fillp_ := "qfillpath_";

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);
enddef;

vardef notdrawpath_(suffix $) =
  $.sw -- (.5[$.ne, $.se] + ($.dist, 0)) -- $.nw -- cycle
enddef;

vardef notoverlay_(suffix $) =
  image(draw fullcircle scaled 5 shifted (.5[$.ne, $.se] + ($.dist, 0));)
enddef;

vardef createFlexNot(suffix s) (expr pic) (suffix orientation) (expr coll) =
  boxit.s(pic);

  string s.orient; s.orient := str orientation;
  pair s.in;
  s.in = .5[s.nw, s.sw] - (sz, 0);
  % s.in1 = .73[s.nw, s.sw] - (sz, 0);
  pair s.cond; s.cond = .5[s.se, s.ne];
  s.dist = .5cm;
  pair s.out; s.out = .5[s.ne, s.se] + (s.dist, 0) + (2sz, 0);
  s.nw = ((ulcorner pic -- (ulcorner pic + (0,10cm))) intersectionpoint (((.5[urcorner pic, lrcorner pic] + (.5cm, 0)) -- urcorner pic) stretched 20)) + (-defaultdx, defaultdy);
  s.sw = ((llcorner pic -- (llcorner pic + (0,-10cm))) intersectionpoint (((.5[urcorner pic, lrcorner pic] + (.5cm, 0)) -- lrcorner pic) stretched 20)) + (-defaultdx, -defaultdy);

  string s.drawp_; s.drawp_ := "notdrawpath_";
  string s.fillp_; s.fillp_ := "notdrawpath_";

  color s.drawcol; s.drawcol := drk(coll);
  color s.fillcol; s.fillcol := lght(coll);

  string s.overlayp_; s.overlayp_ := "notoverlay_";
enddef;

vardef connect(expr l, r, shft) =
  save ll, rr;
  pair ll, rr;
  ll := (xpart l, ypart l - shft);
  rr := (xpart r, ypart l - shft);
  l -- ll -- rr -- r
enddef;

vardef connectL(expr l, r) =
  save ll;
  pair ll;
  ll := (xpart l, ypart r);
  l -- ll -- r
enddef;

vardef connectR(expr l, r) =
  save ll;
  pair ll;
  ll := (xpart r, ypart l);
  l -- ll -- r
enddef;

vardef connectLoop (expr l, r, da, db, dc) =
  pair p[];
  p1 := l - (0, da);
  p2 := p1 + (db, 0);
  p3 := p2 + (0, dc);
  p4 := (xpart r, ypart p3);
  l -- p1 -- p2 -- p3 -- p4 -- r
enddef;

vardef connectLoopP (expr l, r, da, db) =
  pair p[];
  p1 := l - (0, da);
  p2 := p1 + (db, 0);
  p4 := (xpart p2, ypart r);
  l -- p1 -- p2 -- p4 -- r
enddef;

vardef connectRR (expr l, r, da) =
  save p; pair p[];
  p1 := l + (da, 0);
  p2 := (xpart p1, ypart r);
  l -- p1 -- p2 -- r
enddef;

vardef connectAroundRight (expr l, r, box, buffer) =
  save p; pair p[];
  p1 := urcorner box + (buffer, buffer);
  p2 := lrcorner box + (buffer, -buffer);
  l -- (xpart l, ypart p1) -- p1 -- p2 -- (xpart r, ypart p2) -- r
enddef;

vardef connectAroundLeft (expr l, r, box, buffer) =
  save p; pair p[];
  p1 := ulcorner box + (-buffer, buffer);
  p2 := llcorner box + (-buffer, -buffer);
  l -- (xpart l, ypart p1) -- p1 -- p2 -- (xpart r, ypart p2) -- r
enddef;

vardef connectAroundBottom (expr l, r, box, buffer) =
  save p; pair p[];
  p1 := urcorner box + (buffer, -buffer);
  p2 := lrcorner box + (-buffer, -buffer);
  l -- (xpart p1, ypart l) -- p1 -- p2 -- (xpart p2, ypart r) -- r
enddef;

vardef connectAroundTop (expr l, r, box, buffer) =
  save p; pair p[];
  p1 := urcorner box + (buffer, buffer);
  p2 := lrcorner box + (buffer, -buffer);
  l -- (xpart l, ypart p1) -- p1 -- p2 -- (xpart r, ypart p2) -- r
enddef;

vardef drawFlexObj(text s_) =
  forsuffixes s=s_:
    save slocal; path slocal;
    slocal := bpath.s;
    % fixpos(s); fixsize(s);
    % slocal := ;
    fill (scantokens s.drawp_(s)) withcolor s.fillcol;
    draw (scantokens s.fillp_(s)) withcolor s.drawcol;
    if known s.overlayp_:
      draw (scantokens s.overlayp_(s)) withcolor s.drawcol;
    fi
    drawunboxed(s);
  endfor
enddef;

vardef drawObj(suffix s) =
  save slocal; path slocal; slocal := s ;
  fill slocal withcolor s.fillcol;
  draw s.drawpath_ withcolor s.drawcol;
enddef;

vardef drawp_(suffix s) =
  scantokens s.drawp_(s)
enddef;

vardef botn expr e = e enddef;
vardef topn expr e = e enddef;
vardef rtn expr e = e  enddef;
vardef lftn expr e = e enddef;

vardef botnL expr e = e - (0,sz/2.) enddef;
vardef topnL expr e = e + (0,sz/2.) enddef;
vardef rtnL expr e = e + (sz/2.,0) enddef;
vardef lftnL expr e = e - (sz/2.,0) enddef;

vardef nconnect(expr l, r) =
  save ll, rr;
  pair ll, rr;
  ll := (xpart l, ypart l - connectdist);
  rr := (xpart r, ypart l - connectdist);
  l -- ll -- rr -- r
enddef;

vardef connectLoopVertical (expr l, r, da, db) =
  pair p[];
  p1 := l - (0, da);
  p2 := l + (db, -da);
  p4 := r + (0, da);
  p3 := (xpart p2, ypart p4);
  l -- p1 -- p2 -- p3 -- p4 -- r
enddef;

vardef connectLoopHorizontal (expr l, r, da, db) =
  pair p[];
  p1 := l + (da, 0);
  p2 := l + (da, db);
  p4 := r + (-da, 0);
  p3 := (xpart p4, ypart p2);
  l -- p1 -- p2 -- p3 -- p4 -- r
enddef;

newinternal numeric cornersize; cornersize := 3pt;
newinternal numeric textscaledsize; textscaledsize := .5;
newinternal numeric boxyscaledsize; boxyscaledsize := .9;
newinternal string labelAtcolor; labelAtcolor := "col.hidden";

vardef labelAtUF.@#(expr lText) =
  save labelText, scale, intColor;
  color intColor; intColor := scantokens labelAtcolor;
  picture labelText; labelText := textext(lText) scaled textscaledsize;
  scale := boxyscaledsize;
  boxit.@#(image(fill bbox(labelText) yscaled scale cornered cornersize withcolor lght(intColor); 
                 draw bbox(labelText) yscaled scale cornered cornersize withcolor drk(intColor); 
                 draw labelText;));
  @#dx = 0; @#dy = 0;
enddef;

vardef labelAt.@#(expr lText, pos) =
  save _random;
  labelAtUF.@#(lText);
  @#.c = pos;
  path _random; _random := bpath.@#;
enddef;

vardef labelAtNum.@#(expr lText, pos) =
  interim textscaledsize := .8;
  labelAt.@#(lText, pos);
enddef;

% colors

vardef hexrgb(expr Spec) =
  save r, g, b;
  numeric r, g, b;
  r = hex substring (1,3) of Spec;
  g = hex substring (3,5) of Spec;
  b = hex substring (5,7) of Spec;
  show hex "8d";
  show r;
  1/256(r,g,b)
enddef;

color col[]; color acol[];

col0 := (0.5529411764705883, 0.8274509803921568, 0.7803921568627451);
col1 := (1.0, 1.0, 0.7019607843137254);
col2 := (0.7450980392156863, 0.7294117647058823, 0.8549019607843137);
col3 := (0.984313725490196, 0.5019607843137255, 0.4470588235294118);
col4 := (0.5019607843137255, 0.6941176470588235, 0.8274509803921568);
col5 := (0.9921568627450981, 0.7058823529411765, 0.3843137254901961);
col6 := (0.7019607843137254, 0.8705882352941177, 0.4117647058823529);
col7 := (0.9882352941176471, 0.803921568627451, 0.8980392156862745);
col8 := (0.8509803921568627, 0.8509803921568627, 0.8509803921568627);

acol0 := (0.984313725490196, 0.7058823529411765, 0.6823529411764706);
acol1 := (0.7019607843137254, 0.803921568627451, 0.8901960784313725);
acol2 := (0.8, 0.9215686274509803, 0.7725490196078432);
acol3 := (0.8705882352941177, 0.796078431372549, 0.8941176470588236);
acol4 := (0.996078431372549, 0.8509803921568627, 0.6509803921568628);
acol5 := (1.0, 1.0, 0.8);
acol6 := (0.8980392156862745, 0.8470588235294118, 0.7411764705882353);
acol7 := (0.9921568627450981, 0.8549019607843137, 0.9254901960784314);

color col.tagger; col.tagger := col4;
color col.mux; col.mux := col6;
color col.merge; col.merge := col0;
color col.fork; col.fork := col2;
color col.branch; col.branch := col3;
color col.op; col.op := col1;
color col.split; col.split := col5;
color col.join; col.join := col5;
color col.hidden; col.hidden := col8;
color col.pure; col.pure := col7;
color col.gcd; col.gcd := acol1;
color col.generic; col.generic := acol5;

vardef samewidth (suffix a) (text b_) =
  forsuffixes b=b_:
    a.w - a.e = b.w - b.e;
  endfor
enddef;

% drawarrow connect(mux.out, othermux.in1, 0.5u);
% drawarrow connect(othermux.out, box.in0, 0.5u);

endinput
