//make board
b:(til[10]cross til 10)!100#0
//set bombs represeted using -1
b:@[b;10?key b;:;-1]
//neighbours
ns:1_0 1 -1 cross 0 1 -1;
//set values for number of bombs for neighbours
b:@[b;k;:;] abs sum 0^flip b (k:where b>-1)+/:\: ns;
//take dictionary baord and display visual representation with co-ords
disp:{(i,0N),',[;(enlist i:raze string til 10)] flip 10 0N # value  x}
//players board starts off with all null values
pb:@[b;key b ;:;0N];
//given the co-ord key will apply move ending game if bomb or displaying if not 
//for value of zero automatically then apply same function to all neighbours except those that dont exist or already selected 
move:{[x;k]
  if[not count k;:x];
  if[type k;k:enlist k];
	p:b k;
  if[any p=-1;
    0N!" GAME OVER "];
  res:@[x;k;:;p];
  res:.z.s[res;] except[;where not null x] distinct raze inter[;key b] each ns+/:\: k where p=0;
  :res;
	};
//play game pick at random mark all the  bombs, repeat 
play:{[x]
  //based on all the values we already have lets get the values of all their neighbours candidates for bombs or moves
  c:inter[key x] each ns+\:/: y:where x>0;
  //identify where these neighbours a bombs or null if that matches up with number of bomb neighbours for that square then mark them 
  res:x;
  if[count i2:where x[y]=count each i:where each 0>x c;
    res:@[x;;:;-1] raze c[i2]@'i[i2]];
  //indexes where weve marked all surrounding bombs
  i4:where res[y]=count each i3:where each -1=res c;
  if[count i4;
    i6:i4 where 0<count each i5:where each null res[c] i4;
    res:move[res;] raze c[i6]@'i5[i6]];
  $[res~x;
    res:move[res;first 1?where null x];
    res]
  }
/play/[pb]
