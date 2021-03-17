#!/usr/bin/perl 

# reads the gene fa files and calculates ka/ks considering all lineages equal. Prints ka/ks for all lineages and lnL (likelihood).

use strict;
use warnings;
use CodeMLPairwise ;
use FastaRead ;
use Data::Dumper ;
use List::Util qw(min max);

my $Fa = new FastaRead( $ARGV[0] ) ;
my $CodeML = new CodeMLPairwise( "odeml.ctl" ) ;

open OUT, ">$ARGV[1]" ;
my @arraytemp=split  /\// , $ARGV[0] ;
my $name = $arraytemp[ $#arraytemp ];
#print "@".Dumper(@arraytemp)."\n";
#print "name $name\n";
#warn $ARGV[0];
#die;

while ( ! $Fa->eof() ) {
  #	my ( $ihead, $info ) = $Fa->nextfa() ;
  #
  #  my ( $chead, $cseq ) = $Fa->nextfa() ;
  #  my ( $ghead, $gseq ) = $Fa->nextfa() ;
  #  my ( $fhead, $fseq ) = $Fa->nextfa() ;
  #  my ( $phead, $pseq ) = $Fa->nextfa() ;
  #  my ( $clhead, $clseq ) = $Fa->nextfa() ;
  #  my ( $galhead, $galnseq ) = $Fa->nextfa() ;
  my ( $chead, $cseq ) = ("","") ;
  my ( $ghead, $gseq ) = ("","") ;
  my ( $fhead, $fseq ) = ("","") ;
  my ( $phead, $pseq ) = ("","") ;
  my ( $clhead, $clseq ) = ("","") ;
  my ( $galhead, $galseq ) = ("","") ;

  my $foundc=0;
  my $foundg=0;
  my $foundf=0;
  my $foundp=0;
  my $foundcl=0;
  my $foundgal=0;


  for(my $i=0;$i<6;$i++){
    my ( $head, $seq ) = $Fa->nextfa() ;
#    print $head."\n";
    if($head =~ /^>Du/){ #Dugong
      ( $chead, $cseq )= ( $head, $seq );
      $foundc=1;
    }

    if($head =~ /^>Se/){ #Seacow
      ( $ghead, $gseq )= ( $head, $seq );
      $foundg=1;
    }

    if($head =~ /^>Ma/){ #Manatee
      ( $fhead, $fseq )= ( $head, $seq );
      $foundf=1;
    }

    if($head =~ /^>Hu/){ #Human
      ( $phead, $pseq )= ( $head, $seq );
      $foundp=1;
    }

    if($head =~ /^>Mo/){ #Mouse
      ( $clhead, $clseq )= ( $head, $seq );
      $foundcl=1;
    }

    if($head =~ /^>El/){ #Elephant
      ( $galhead, $galseq )= ( $head, $seq );
      $foundgal=1;
    }
  }

  my $amountFound = 0;
  my $l;
  if($foundc == 1 ){ $amountFound++; $l = length( $cseq ); }
  if($foundg == 1 ){ $amountFound++;  }
  if($foundf == 1 ){ $amountFound++;  }
  if($foundp == 1 ){ $amountFound++;  }
  if($foundcl == 1 ){ $amountFound++;  }
  if($foundgal == 1 ){ $amountFound++;  }

  if($amountFound<2){
    
      die "ERROR: Only found ".$amountFound."species, exiting\n";
  }

  if(!$foundc == 1 ){
    die "ERROR: COL not found exiting\n";
  }

  # cut last 3 bases, otherwise might be stop and codeml crashes
  $cseq= substr( $cseq, 0, $l-3 ) ;
  $gseq= substr( $gseq, 0, $l-3 ) ;
  $fseq= substr( $fseq, 0, $l-3 ) ;
  $pseq= substr( $pseq, 0, $l-3 ) ;
  $clseq= substr( $clseq, 0, $l-3 ) ;
  $galseq= substr( $galseq, 0, $l-3 ) ;
  
  #
  #	$info =~ /name: (\S+)gene/ ;
  #my $name = $1 ;
  #
  my $Ns    = ( $cseq =~ tr/Nn/Nn/ ) ;
  my $ACGTs = ( $cseq =~ tr/ACGTacgt/ACGTacgt/ ) ;
  #  print $ACGTs;

  if ( length($cseq)% 3 == 0 ) {

    if ( $cseq =~ /^N+$/ ) {
      print OUT "$name: unaligned\n" ;
    } else {

      my $species = [ "Dugong" ];
      my $seq     = [ $cseq  ];

      if($foundg == 1 ){
	push(@{$species} , "Seacow");
	push(@{$seq}     , $gseq);
      }

      if($foundf == 1 ){
	push(@{$species} , "Manatee");
	push(@{$seq}     , $fseq);
      }

      if($foundp == 1 ){
	push(@{$species} , "Human");
	push(@{$seq}     , $pseq);
      }

      if($foundcl == 1 ){
	push(@{$species} , "Mouse");
	push(@{$seq}     , $clseq);
      }
      
      if($foundgal == 1 ){
	push(@{$species} , "Elephant");
	push(@{$seq}     , $galseq);
      }

      my ( $x, $error ) = $CodeML->calculate( $species, $seq ) ;
      #print "test ".Dumper($x);
      if ( $x != 0 ) {
	my @pr ;
	print OUT "".join( "\t", ( $name, $l, $Ns/($Ns+$ACGTs), )) ;
	foreach my $n (keys %{$x}){
	  print OUT "\t".$n."\t".join("\t",@{$x->{$n}});
	}


	print OUT "\n" ;
      } else {
	print OUT "$name: error $error\n" ;
      }
    }
  } else {
    print OUT "$name: not mod3\n" ;
  }

}
