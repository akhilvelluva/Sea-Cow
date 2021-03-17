
##This script needed the codeml.ctl and the tree file (phylip format)
##This will run with the script called kaks_codeml_lineage.pl
package CodeMLPairwise ;

use strict ;

my $configfile = "codeml.ctl" ;
my $treefile = "tree"; 
my $binary = "/usr/local64/bin/codeml" ;

sub new
{
	my ( $class, $configfile_, $binary_ ) = @_ ;
	my $self = {} ;
	$self->{config} = $configfile ;
	$self->{tree} = $treefile;
	$self->{config} = $configfile_ if ( $configfile_ ) ;
	$self->{binary} = $binary ;
	$self->{binary} = $binary_ if ( $binary_ ) ;
	
	bless( $self, $class ) ;
	return $self ;
}

sub calculate
{
	my ( $self, $names, $seqs ) = @_ ;


	# make tmp directory
	my $x = int( rand(1000) ) ;
	mkdir( "/tmp/$$-$x" ) ;
	chdir( "/tmp/$$-$x" ) ;

	# make sequence file 
	my $length = length( $seqs->[0] ) ;
	my $nr_seq = scalar @$seqs ;
	open O, ">seqs.nuc" ;
	print O "  $nr_seq  $length\n" ;
	for ( my $i = 0 ; $i < @$seqs ; $i++ ) {
		print O $names->[$i], "  ", $seqs->[$i], "\n" ;
	}
	close O ;
	
	# copy config file
	system( "cp " . $self->{config} . " ./codeml.ctl" ) ;
	
	#copy tree file
	system( "cp " . $self->{tree} . " ./outtree" ) ;
	
	# run codeml
	my $retsys = system( $self->{binary} . " 2>log.stderr >&2" ) ;

	# parse output
	my $ret = {} ;
	# no error
	if ( $retsys == 0 ) {
	  open I, "<mlc" or die "cannot open ";
	  #warn "bird4 ".$_."#";
	  while (<I>) {
	    #warn "hi";
	    #warn "data ".$_."\n";
	    if ( /lnL\((.*)\):\s+(\S+)\s+/) {

	      my $lnL ="lnL:$2";
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      my $tl;
	      $tl=$_; 
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      my $kappa;
	      $kappa=$_;
	      $_ = <I> ;
	      $_ = <I> ;
	      my $omega;
	      $omega=$_;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      $_ = <I> ;
	      my $dntree;
	      $dntree=$_;
	      $_ = <I> ;
	      my $dstree;
	      $dstree=$_;
	      #if( /^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/){
		#$tl= $4;
	      
		  
#	      $ret->{$lnL}=[$tl, $kappa, $omega, $dntree, $dstree];
	      chomp($tl);
	      chomp($kappa);
	      chomp($omega);
	      chomp($dntree);
	      chomp($dstree);

	      $ret->{$lnL}=[$tl."\t".$kappa."\t".$omega."\t".$dntree."\t".$dstree];

	      #			if ( /\d \((.*)\) ... \d \((.*)\)/ ) {
	      #				my $species="$2.$1" ;
	      #				$_ = <I> ;
	      #				$_ =~ /lnL =([\d-\.]+)/ ;
	      #				my $lnL = $1 ;
	      #				$_ = <I> ;
	      #				$_ = <I> ;
	      #				$_ = <I> ;
	      # XXX this will fail if there is a "nan" in the output. Lines will then contain the name in the output (becuase this is the previous $1)
	      # $_ =~ /t=\s*([\d\.-]+)\s*S=\s*([\d\.-]+)\s*N=\s*([\d\.-]+)\s*dN\/dS=\s*([\d\.-]+)\s*dN=\s*([\d\.-]+)\s*dS=\s*([\d\.-]+)\s*/ ;
	      # this would probably be the fix (gives nan on the output)
	      #				$_ =~ /t=\s*(\S+)\s*S=\s*(\S+)\s*N=\s*(\S+)\s*dN\/dS=\s*(\S+)\s*dN=\s*(\S+)\s*dS=\s*(\S+)\s*/ ;
	      #				my ( $t, $S, $N, $dnds, $dN, $dS ) = ( $1, $2, $3, $4, $5, $6 ) ;
	      #				$ret->{$species} = [ $lnL, $t, $S, $N, $dnds, $dN, $dS ] ;
	    }
	  }
	  close I ;
	  # cleanup
	  #	system( "rm -rf /tmp/$$-$x" ) ;
	  
	  return $ret ;
	} else { # error, get last output line (which is probably the error message)
	  open ERR, "<log.stderr" ;
	  my $lastline ;
	  while (<ERR>) { $lastline=$_ unless ( $_ =~ /^\s+$/ ) ; } 
	  close ERR ;
	  #         system( "rm -r /tmp/$$-$x" ) ;
	  chomp $lastline ;
	  return( 0, $lastline ) ;
	}
      }

1 ;
