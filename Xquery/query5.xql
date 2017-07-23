(:
Author : Arun Rajan, Stony Brook University
I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else. 
:)
xquery version "3.1";
declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace xsi ="http://www.w3.org/2001/XMLSchema-instance";
declare namespace myNS = "proj3ns";
declare namespace functx = "http://www.functx.com";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html5";
declare option output:media-type "text/html";

declare function local:rec_body($root) as node()*
{   for $x in $root
    for $y in $root
    where $y/name1/myNS:cname = $x/name2/myNS:cname
        and $y/name2/myNS:cname != $x/name1/myNS:cname
    return
        <li>
            <name1>
                {$x/name1/myNS:cname}
            </name1>
            <name2>
                {$y/name2/myNS:cname}
            </name2>
        </li>
};

declare function local:fix($x) as node()* 
{ let $res := local:rec_body($x)
  let $y := $x
  let $uni:=
  (for $singleNode in $res
    where (not(functx:is-node-in-sequence-deep-equal($singleNode,$y)))
       return $y union $singleNode
   )
   return if(empty($uni except $x)) then $y
          else local:fix($uni)
};

declare function local:final($x) as node()*{
      for $i in (1 to count($x))
      where $x[$i]//name1/myNS:cname < $x[$i]//name2/myNS:cname 
      order by $x[$i]//name1/myNS:cname, $x[$i]//name2/myNS:cname
      return
         $x[$i]
};

declare function functx:is-node-in-sequence-deep-equal
      ( $node as node()? ,
        $seq as node()* )  as xs:boolean {
       some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
};
    
declare function functx:distinct-deep
      ( $nodes as node()* )  as node()* {
        for $seq in (1 to count($nodes))
        return $nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
                              .,$nodes[position() < $seq]))]
};

<html>
    <body>
        <ul>
            {
                let $X:=(
                for $c1 in doc("tdb3.xml")//myNS:contestant
                for $c2 in doc("tdb3.xml")//myNS:contestant
                for $aud1 in $c1//myNS:audition
                for $aud2 in $c2//myNS:audition
                let $avg1 := avg($c1//myNS:score/@value)
                let $avg2 := avg($c2//myNS:score/@value)
                where $aud2/myNS:aid = $aud1/myNS:aid
                      and     abs($avg2 - $avg1) <= 0.2
                      and $aud2/myNS:sid = $aud1/myNS:sid
                      and $c2/myNS:cid != $c1/myNS:cid
                order by $c1/myNS:cname,$c2/myNS:cname
                return <li>
                       <name1>{$c1/myNS:cname}</name1>
                       <name2>{$c2/myNS:cname}</name2>
                       </li>
                    )
                return 
                    local:final(functx:distinct-deep(local:fix(functx:distinct-deep($X))))
            }</ul>
    </body>
</html>
       