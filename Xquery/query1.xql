(:
Author : Arun Rajan, Stony Brook University
I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else. 
:)
xquery version "3.1";
declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace xsi ="http://www.w3.org/2001/XMLSchema-instance";
declare namespace myNS = "proj3ns";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace functx = "http://www.functx.com";
declare function functx:is-node-in-sequence-deep-equal
      ( $node as node()? ,
        $seq as node()* )  as xs:boolean {
       some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
} ;
    
declare function functx:distinct-deep
      ( $nodes as node()* )  as node()* {
        for $seq in (1 to count($nodes))
        return $nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
                              .,$nodes[position() < $seq]))]
};
declare option output:method "html5";
declare option output:media-type "text/html";
<html>
    <body>
        <ul>
        {
            let $X:= (
            for $c1 in doc("tdb3.xml")//myNS:contestant
            for $c2 in doc("tdb3.xml")//myNS:contestant
            for $aud1 in $c1//myNS:audition
            for $aud2 in $c2//myNS:audition
            for $show1 in doc("tdb3.xml")//myNS:show
            for $show2 in doc("tdb3.xml")//myNS:show
            where $c2/myNS:cid != $c1/myNS:cid
            and $aud2/myNS:sid = $show2//myNS:sid
            and $aud1/myNS:sid = $show1//myNS:sid
            and $show2//myNS:sdate = $show1//myNS:sdate
            and $aud2/myNS:aid = $aud1/myNS:aid
            and $aud2//myNS:score/@value = $aud1//myNS:score/@value
            and $c2/myNS:cname > $c1/myNS:cname
            order by $c1/myNS:cname, $c2/myNS:cname
            return
            <li>
                {$c1/myNS:cname}
                {$c2/myNS:cname}
            </li>
            )
            let $ans := functx:distinct-deep($X)
            return $ans
        }
        </ul>
    </body>
</html>