
// variables used in functions

var config = {min_GQ: 20, min_AB: 0.20, min_DP: 6}

// end variables used in functions

// hi quality variants
function hq1(sample) {
  if (sample.unknown || (sample.GQ < config.min_GQ)) { return false; }
  if ((sample.AD[0] + sample.AD[1]) < config.min_DP) { return false; }
  if (sample.hom_ref){
      return sample.AB < 0.02
  }
  if(sample.het) {
      return sample.AB >= config.min_AB && sample.AB <= (1 - config.min_AB)
  }
  return sample.AB > 0.98
}

// end hi quality variants

// functions to be use with --family-expr

function segregating_dominant(s) {
  if(!hq1(s)){ return false; }
  if(variant.CHROM == "chrX" || variant.CHROM == "X") { return segregating_dominant_x(s); }
  if (s.affected) {
     return s.het
  }
  return s.hom_ref && s.AB < 0.01
}

function find_het_aff_hom_ref_unaff_hq(indiv) {
  if(!hq1(indiv)){ return false; } // test first if quality is ok. It is faster since return false and go the the next line directly
  return indiv.het == indiv.affected && indiv.hom_ref == !indiv.affected
  // indiv.het: take the GT field of FORMAT of indiv that is 0/1
  // indiv.affected: take indiv that is 2 in the ped file
  // indiv.hom_ref: the GT field of FORMAT of indiv that is 0/0
  // !indiv.affected: take indiv that is 1 in the ped file
}

function find_het_aff_hom_ref_unaff(indiv) { // as above but without the hq1 filtering
  return indiv.het == indiv.affected && indiv.hom_ref == !indiv.affected
}


// end functions to be use with --family-expr