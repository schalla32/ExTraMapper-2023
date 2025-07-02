# Convert UCSC xenoRefGene.txt.gz to GTF format
# bash xenoRefGene_to_gtf.sh

ASSEMBLY="panTro6"
TABLE="xenoRefGene"
OUTPUT_PREFIX="org2"

wget -q "http://hgdownload.soe.ucsc.edu/goldenPath/${ASSEMBLY}/database/${TABLE}.txt.gz"

echo "to GenePred format"
gunzip -c "${TABLE}.txt.gz" > "${TABLE}.genePred"

# download genePredToGtf using conda or bioconda
if ! command -v genePredToGtf &>/dev/null; then
  echo "Downloading 'genePredToGtf' binary..."
  wget -q -O genePredToGtf http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/genePredToGtf
  chmod +x genePredToGtf
  PATH="./:$PATH"
fi

# Convert GenePred to GT
genePredToGtf -utr "${TABLE}.genePred" "${OUTPUT_PREFIX}.gtf"

# compress gtf
gzip -f "${OUTPUT_PREFIX}.gtf"

echo "Done! Output: ${OUTPUT_PREFIX}.gtf.gz"
