# Installation

## System installation

You can install `graphiti` globally using the following:

```
mkdir -p ~/texmf/tex/metapost
git clone https://github.com/VCA-EPFL/graphiti-mp ~/texmf/tex/metapost/graphiti-mp
```

## Local installation

Otherwise, the following files can just be copied alongside the main `tex` file:

Copy:
    - t-fonts.tex
    - t-graphiti.tex
    - graphiti.mp

Create a file `myDiagram.tex`, look at the example `running-*.tex`

Compile with `context --purgeall running-*`


# Basics 

The library is typically used as follow: 

```
% Preamble always present
u := 1cm;
dist := .5u;
pickup pencircle scaled sz;
interim ahlength := 2pt;
interim crossingscale := 5pt;

% Declaration of the instances
...

% Constraints on layout
...


% Draw command for instances
...

% Changing the pencil size for thinner drawings for connections
pickup pencircle scaled 0.03u;

% Drawing labels
...

% Drawing connections
...

```

## Box 

`createFlexBox(instanceName, textWithinBox, numInPort, numOutPort, color)`

`textWithinBox` will typically be "textext("pieceoflatex")" to create a picture from a piece of latex that is then manipulated by the library as a picture.

> Critically, `instanceName` must only contain letters, no digits or special characters.

## Box vs Op

Op are slighty more rounded, and it has an extra parameter to make it look like a pipelined operator. 

## Padding stuff

After the declaration of an instance, we need to set some inner padding between the label and the box boundary (we typically use the default value):

`createFlexOp(modn, textext("Pure $\cdot \% \cdot$"), 1, 1, 0, col.pure); modn.dy = defaultdx; modn.dx = defaultdx;` 


## Constraints 

All instances have the following properties that can be used to add constraints: 

- middle of edges: north (n), south (s), west (w) and east(e)
- corners: nw,sw,ne,se

Specific instances have custom properties: 
- Branch has (in) (out0) (out1) corresponding to its inputs and outputs positions and (lcond) and (rcond) to position the condition of the branch either on the left or on the right.

- Op and Box have a variadic number of input and output custom properties, depending on what was specified in the declaration of the instance: (in0), (in1), ... (inl), (out0)...

- Merge has  (in0) (in1) (out) corresponding to its inputs and outputs positions and (lcond) and (rcond) to position the condition of the merge either on the left or on the right.



Typically we pick one node that is an anchor node and then list constraints.

```
% the splita instance's output feeds into the fork's input:
forkb.in0 = splita.out0 + (0,-dist);
```

We often specify everything is a multiple of `dist`, a constant defined in the preamble.

Sometimes we just want to constraint the x or the y part of a position, but not the other one (for example horizontally aligne would constraint just the y part):

```
xpart joina.e = xpart modn.w;
```

## Special case: taggers

We currently don't have a nice abstracted way to do a tagger, hence it is typically in the middle of the constraints.
 Here is what we do (tagger is always wrapping from the left):

```
path combinedBB;
% We create a path between all the nodes we want to wrap (this path won't be drawn as we do not explicitly ever draw it)
% And then we get a bounding box around these nodes with bbox:
combinedBB := bbox (bpath.node1 -- bpath.node2 -- bpath.node3);
% We create a tagger with an empty picture with some generic padding:
createFlexTagger(tagger, nullpicture, (.5u, .7u), col.tagger);
% We constraint the bounding box with the inside of the tagger
tagger.nw = ulcorner combinedBB + (-.5u,.5u);
tagger.se = lrcorner combinedBB + (.5u,-.5u);
```
## Intermediate variables

Sometimes it is useful to give a short name to a specific position described relatively, it is done as follow: 

```
pair inp;
inp := puref.in0 + (0, dist);
```

Then `inp` can be used in place of any coordinate.


## Drawing all the objects

```
drawFlexObj(forka, forkb, joina, splita, joine, joinf, puref, pureg);
```

## Connections 

Direct connections that do not involve crossing can be drawn directly. There are different kind of connections.

### Vertical connections

The main one is to connect things vertically, with 
`connect(topCoord, bottomCoord, distanceToTurn)`.
Connect allwos to conenct boxes that are not perfectly aligned, and it will draw an arrow that offsets:
```
|
|------
      |
      |
      v
``` 
The `distanceToTurn` gives the clearing distance where the arrow will turn. We typically use a clearing distance of `.5dist-sz-1pt`.

In summary a vertical connection looks like:

```
drawarrow connect(botn splita.out1, topn forka.in0, .5dist-sz-1pt);
```

### Loop connections 

TODO 

## Colors 

Many semantic colors are available, one should always use semantic colors, for unity: 
  - col.tagger
  - col.mux
  - col.merge
  - col.fork
  - col.branch
  - col.op
  - col.split
  - col.join
  - col.pure
  - col.gcd

And two generic colors:
  - col.hidden
  - col.generic
