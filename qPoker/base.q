//set random seed based on .z.p
system"S ",string `int$.z.p mod 0Wi-1;
//deck of cards
deck:(`float$2+til 13) cross `S`C`H`D
//scoring system 
hc:{r:max x[;0];r+sum 6 4 2 0+0.1*desc 4#x[;0] except r}                          //high card
p:{r:first where 2=count each group x[;0];r+sum 4 2 0+0.1*desc 3#x[;0] except r}  //pair
tp:{$[2=count r:where 2=count each group x[;0];max[r]+0.1*max x[;0] except r;0n]} //two pair
tok:{first asc where 3=count each group x[;0]}                                    //three of a kind
s:{$[all (1_i:deltas r:asc x[;0]) in 1 9f;max r where i=1;0n]}                    //straight `S`S`S`S`S,'2 3 4 5 13 should return 5
f:{$[1=count distinct x[;1];max x[;0];0n]}                                        //flush `S`S`S`S`S,'2 3 4 5 6 returns 6
b:{$[all (r:2#desc count each group x[;0])='3 2;sum 1 0.1*key r;0n]}              //boat
fok:{r:first where 4=count each group x[;0];r+0.1*first x[;0] except r}           //four of a kind
sf:{s[x]&f x}                                                                     //straightFlush `S`S`S`S`S,'2 3 4 5 6 returns 6

score:{last r where not null r:0 20 40 60 80 100 120 140 160+(hc;p;tp;tok;s;f;b;fok;sf)@ \:x where 0<>count each x}

//holdem
//no. players
n:3
flop:turn:river:()
com::flop,turn,river
perms:{r where 3=count each distinct each r:x cross x cross x} til 5
players:n#`p1`p2`p3`p4`p5`p6
buyIn:1000
stacks:players!n#buyIn
sb:10
bb:20
betting:()!()
passAction:{handPlayers::1 rotate handPlayers}
check:{0N!string[x]," checks";passAction[]}
fold:{0N!string[x]," folds";folded,:x;handPlayers::handPlayers except x}
bet:{0N!string[x]," bets ",string y;betting+:b:enlist[x]!enlist y;stacks-:b;passAction[]}
dealer:0
hands::com;{r r2?max r2:score each r:x,/:com perms} each {x!value each x} players except folded
//by hand
newHand:{
 //TODO removew rebuy if falling below 0
 @[`stacks;where stacks<0;:;buyIn];
 pot::0;
 folded::();
 handPlayers::players except folded;
 `flop`turn`river set\:();
//com at start makes view dependant on com
 (players,`rd) set' (2*til 1+n) _ -52?deck;
 @[`stacks;;-;sb,bb]players mod[;n] dealer + 1 2; 
 @[`betting;;+;sb,bb]players mod[;n] dealer + 1 2;
 action::mod[;n] dealer+3;
 }

disp:{0N!string[x]," is: "," " sv (,).'string value x}
//flop
doFlop:{`flop`rd set' 0 3 _ rd;
  action::mod[;n] dealer+3;
  disp `flop}
//turn
doTurn:{`turn`rd set' 0 1 _ rd;
  action::mod[;n] dealer+1;
  disp `turn}
//river
doRiver:{`river`rd set' 0 1 _ rd;
  action::mod[;n] dealer+1;
  disp `river}

takeTurn:{
  //if you dont match biggest bet you must bet or fold otherwise bet or check
  opts:$[max[betting]<>betting x;
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2;
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
  r:first 1?opts;
  $[0=r; bet[x;betSize[x]];
      1=r;check x;
    fold x];
    toGo::toGo except x;
    }

betSize:{
  minBet:max[betting]-0^betting[x];
  //only raise by big blind if betting less its becuase your all in
  maxBet:(minBet+bb) & allIn:stacks x; 
  if[maxBet<minBet;:allIn]; 
  minBet+first 1?0 0 0 0 0,r where not mod[;5]r:til maxBet-minBet 
  }

roundBetting:{
 toGo::handPlayers;   
 while[(1=count handPlayers) or (0<count toGo) or 1<count distinct value handPlayers#betting;takeTurn first handPlayers];
 pot+:sum betting;
 betting-:betting
 }
settle:{
  winners:where r=max r:score each hands;
  winners:winners inter handPlayers;
  0N!"Winner(s) of hand are: "," " sv string winners ;
  @[`stacks;winners;+;pot div count winners]
  }
hand:{  
 newHand[];
 roundBetting[];
 doFlop[];
 roundBetting[];
 doTurn[];
 roundBetting[];
 doRiver[];
 roundBetting[];
 settle[] 
 }
