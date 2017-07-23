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

declare function functx:is-node-in-sequence-deep-equal
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {
   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
};
 
<html>
    <body>
        <ul>
            {
                let $X:=
                (
                for $c in doc("tdb3.xml")//myNS:contestant
                let $sids := $c//myNS:sid
                order by $c/myNS:cname
                return 
                    <result>
                        <cont>
                            {$c/myNS:cid}
                            {$c/myNS:cname}
                            {$sids}
                        </cont>
                    </result>
                )
                let $Y := $X
                for $ele1 in $X/cont
                for $ele2 in $Y/cont
                let $seq1 := $ele1/myNS:sid
                let $seq2 := $ele2/myNS:sid
                where  $ele1/myNS:cid != $ele2/myNS:cid
                     and(every $singleSid in $seq2 satisfies (functx:is-node-in-sequence-deep-equal($singleSid,$seq1)))
                order by $ele1/myNS:cname,$ele2/myNS:cname
                return
                    <li>
                     { $ele1/myNS:cname }
                     {$ele2/myNS:cname}
                   </li>
             }
        </ul>
    </body>
</html>