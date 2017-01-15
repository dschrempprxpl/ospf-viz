#!/usr/bin/perl  
use Data::Dumper;
use XML::XPath;

my $xp = XML::XPath->new ("ospf.xml");
my $router;
my $ip;
my @parts;
my @type;

print "digraph OSPF { \n";
print "layout=circo\n";
#print "size=\"20,20\"\n";

foreach my $router ($xp ->find('//ospf-database[lsa-type="Router"]') ->get_nodelist) 
{
    my $routerID = $router ->find('lsa-id') ->string_value;
    
    @parts=split(/\./,$routerID);
    $routerID=join("-",@parts);
    my $linkCount= $router->find('ospf-router-lsa/link-count')->string_value;
    print "\"$routerID\" [ shape= box];\n";

	foreach $stub ($router ->find('ospf-router-lsa/ospf-link[link-type-name = "PointToPoint" ]') ->get_nodelist)
	{

	    my $link = $stub->find('link-id')->string_value;
	    @parts=split(/\./,$link);
	    $link=join("-",@parts);
	    print "\"$routerID\" -> \"$link\" ;\n";
	}
	foreach $stub ($router ->find('ospf-router-lsa/ospf-link[link-type-name = "Transit" ]') ->get_nodelist)
	{

	    my $link = $stub->find('link-id')->string_value;
	    @parts=split(/\./,$link);
	    $link=join("-","DR",@parts);
#	    print "\"$routerID\" -> \"$link\" ;\n";
	}
	foreach $stub ($router ->find('ospf-router-lsa/ospf-link[link-type-name = "Stub" ]') ->get_nodelist)
	{

	    my $link = $stub->find('link-id')->string_value;
	    @parts=split(/\./,$link);
	    $link=join("-","Stub",@parts);
#	    print "\"$routerID\" -> \"$link\" ;\n";
	}

}

print "\n}\n";
