#' The World Checklist of Vascular Plants: names
#'
#' `r lifecycle::badge("stable")`
#'
#' A dataset containing the taxonomic data from the WCVP (Version 15, extracted Jan 2026).
#'
#' @format A data frame with 1,442,392 rows and 31 variables:
#' \describe{
#'   \item{plant_name_id}{World Checklist of Vascular Plants (WCVP) identifier}
#'   \item{ipni_id}{International Plant Name Index (IPNI) identifier. Missing
#'   values indicate that the name has not been matched with a name in IPNI.}
#'   \item{taxon_rank}{The level in the taxonomic hierarchy where the taxon
#'   nname fits. Some infraspecific names are unranked and will have no value
#'   iin this column.}
#'   \item{taxon_status}{Indication of taxonomic opinion re the name.}
#'   \item{family}{The name of the family to which the taxon belongs. (The
#'   highest rank at which names are presented in WCVP).}
#'   \item{genus_hybrid}{Indication of hybrid status at genus level:
#'   \+ indicates a graft-chimaera and × indicates a hybrid.}
#'   \item{genus}{The name of the genus to which the record refers.}
#'   \item{species_hybrid}{Indication of hybrid status at species level:
#'   \+ indicates a graft-chimaera and × indicates a hybrid.}
#'   \item{species}{The species epithet which is combined with the genus name
#'   to make a binomial name for a species. Empty when the taxon name is at the
#'   rank of genus.}
#'   \item{infraspecific_rank}{The taxonomic rank of the infraspecific epithet.
#'   Empty where the taxon name is species rank or higher. For more information,
#'   see the International Code of Nomenclature for algae, fungi and plants:
#'   https://www.iapt-taxon.org/nomen/main.php}
#'   \item{infraspecies}{The infraspecific epithet which is combined with a
#'   binomial to make a trinomial name at infraspecific rank. Empty when taxon
#'   name is at species rank or higher.}
#'   \item{parenthetical_author}{The author of the basionym. Empty when there is no basionym.}
#'   \item{primary_author}{The author or authors who published the scientific name. Missing values indicate instances where authorship is non-applicable (e.g. autonyms) or unknown.}
#'   \item{publication_author}{The author or authors of the book where the scientific name is first published, who are different from the primary author. Missing values indicate instances where the primary author is also the author of the book or non-applicable (e.g. autonyms).}
#'   \item{place_of_publication}{The journal, book or other publication in which the taxon name was effectively published. Missing values indicate instances where publication details are unknown or non-applicable (e.g. for autonyms). Abbreviated for brevity.}
#'   \item{volume_and_page}{The volume and page numbers of the original publication of the taxon name, where "5(6): 36" is volume 5, issue 6, page 36. Missing values indicate instances where publication details are unknown or non-applicable (e.g. for autonyms). Not all records include issue number.}
#'   \item{first_published}{The year of publication of the name, enclosed in parentheses. Missing values indicate instances where publication details are unknown or non-applicable (e.g. for autonyms).}
#'   \item{nomenclatural_remarks}{Remarks on the nomenclature. Preceded by a comma and space (", ") for easy concatenation.}
#'   \item{geographic_area}{The geographic distribution of the taxon (for names of species rank or below): a generalised statement in narrative form. See \url{https://powo.science.kew.org/about-distribution#geography} for details.}
#'   \item{lifeform_description}{The lifeform (or lifeforms) of the taxon. Terms refer to a modified version of the Raunkiær system. Where there are multiple lifeforms, the most common is listed first. Missing values if unknown. See \url{https://powo.science.kew.org/about-distribution#lifeform} for a glossary of terms used.}
#'   \item{climate_description}{Habitat type of the taxon, derived from
#'   published habitat information. }
#'   \item{taxon_name}{Concatenation of genus with species and, where
#'   applicable, infraspecific epithets to make a binomial or trinomial name.}
#'   \item{taxon_authors}{Concatenation of parenthetical and primary authors.
#'   Missing values indicate instances where authorship is unknown or
#'   non-applicable (e.g. autonyms). }
#'   \item{accepted_plant_name_id}{The ID of the accepted name of this taxon. Where the taxon_status is "Accepted", this will be identical to the plant_name_id value. Maybe empty if taxon status is unplaced, illegitimate, or in some cases where the accepted name is not a vascular plant (e.g. a moss, alga or animal).}
#'   \item{basionym_plant_name_id}{ID of the original name that taxon_name was
#'   derived from (i.e. the basionym). Empty if there have been no name changes.}
#'   \item{replaced_synonym_author}{The author or authors responsible for
#'   publication of the replaced synonym. Empty when the name is not a
#'   replacement name based on another name.}
#'   \item{homotypic_synonym}{The synonym type - TRUE if homotypic synonym, otherwise NA. See more information, see the International Code of Nomenclature for algae, fungi and plants: \url{https://www.iapt-taxon.org/nomen/main.php}}
#'   \item{parent_plant_name_id}{ID for the parent genus or parent species of an
#'   accepted species or infraspecific name. Empty for non accepted names or
#'   where the parent has not yet been calculated.}
#'   \item{powo_id}{Identifier required to look up the name directly in Plants
#'   of the World Online (POWO).}
#'   \item{hybrid_formula}{Parents of hybrid.}
#'   \item{reviewed}{Flag indicating whether the family to which the taxon
#'   belongs has been peer reviewed.}
#'
#'   ...
#' }
#' @source \url{http://sftp.kew.org/pub/data-repositories/WCVP/wcvp.zip}
#' @examples
#' \donttest{
#' data(wcvp_checklist_names)
#' head(wcvp_checklist_names)
#' }
"wcvp_checklist_names"

#' The World Checklist of Vascular Plants: distributions
#'
#' `r lifecycle::badge("stable")`
#'
#' A dataset containing the distribution data from the WCVP, mapped to the
#' Biodiversity Information Standards (TDWG) World Geographical Scheme for
#' Recording Plant Distributions (WGSRPD)
#'
#' @format A data frame with 1,990,342 rows and 11 variables:
#' \describe{
#'   \item{plant_locality_id}{Sequential number.}
#'   \item{plant_name_id}{WCVP Identifier, corresponding to the filed of the same name in checklist_names.txt.}
#'   \item{continent_code_l1}{Numerical botanical continent code (TDWG level 1).}
#'   \item{continent}{Botanical continent (TDWG Level 1). See \url{https://www.tdwg.org/standards/wgsrpd/} for details.}
#'   \item{region_code_l2}{Numerical botanical region code (TDWG level 2).}
#'   \item{region}{Botanical region (TDWG Level 2). See \url{https://www.tdwg.org/standards/wgsrpd/} for details.}
#'   \item{area_code_l3}{Numerical botanical area code (TDWG level 3).}
#'   \item{area}{Botanical area (TDWG Level 3). See \url{https://www.tdwg.org/standards/wgsrpd/} for details.}
#'   \item{introduced}{Introduced status of the taxon: 0 if native; 1 if introduced.}
#'   \item{extinct}{Local extinction status of the taxon: 0 if extant; 1 if extinct in region.}
#'   \item{location_doubtful}{Trustfulness of status: 1 if doubtfully present; else 0.}
#' }
#' @source \url{http://sftp.kew.org/pub/data-repositories/WCVP/wcvp.zip}
#' @examples
#' \donttest{
#' data(wcvp_checklist_distribution)
#' head(wcvp_checklist_distribution)
#' }
"wcvp_checklist_distribution"


