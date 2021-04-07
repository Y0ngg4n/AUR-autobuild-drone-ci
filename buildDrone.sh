#!/bin/bash

packagesfile=packages.txt
outfile=.drone.yml
buildimage=yonggan/docker-makepkg-drone-ci
volumename=oblivion
volumepath=/oblivion
buildjobfile=buildjob.txt
apiurl=https://nexus.oblivioncoding.pro/service/rest/v1

function registerPackage(){
        echo "Registering Package $1"
	
	# Check if custom command
	IFS='^' read -ra ADDR <<< "$1"
	if [ ${#ADDR[@]} -eq 1 ]; then
		# No Commands specified
		echo "  - name: $1
    image: $buildimage
    failure: ignore
    volumes:   
      - name: $volumename
        path: $volumepath
    environment:
      DOCKER_MAKEPKG_PATH: /drone/src/"\$DRONE_STEP_NAME"
      DOCKER_OUT_PATH: $volumepath
      REPO_API_URL: $apiurl
" >> "$outfile"

	else
	   packageName=${ADDR[0]}
	   echo "  - name: $packageName
    image: $buildimage
    failure: ignore
    volumes:
      - name: $volumename
        path: $volumepath
    environment:
      DOCKER_MAKEPKG_PATH: /drone/src/\$DRONE_STEP_NAME
      DOCKER_OUT_PATH: $volumepath
      REPO_API_URL: $apiurl
    commands:" >> "$outfile"

                for i in "${ADDR[@]}"; do
			if [ "$i" != "$packageName" ] 
				then
                        		echo "      - $i" >> "$outfile"
			fi
                done
                                        echo "      - /bin/su -s /bin/sh -c '/run.sh /drone/src/\"\$DRONE_STEP_NAME\" \"\$OUTPUT_DIR\"' notroot" >> "$outfile"
		echo "
" >> "$outfile"
	fi

}

function header(){
	echo "kind: pipeline
type: docker
name: default
clone:
  git:
    image: plugins/git
    recursive: true


steps:

  - name: submodules
    image: alpine/git
    commands:
      - git submodule update --recursive --remote

" > "$outfile"
}

function registerBuildStep(){
	echo "Registering Build Job"
		
	cat "$buildjobfile" >> "$outfile"
}

function writeVolumes(){
	echo "Write Volumes"
	echo "

" >> "$outfile"
	echo "volumes:
  - name: oblivion
    temp: {}" >> "$outfile"
}

# Write Header
header

# Read packages.txt
while read line; do
	registerPackage "$line"
done <"$packagesfile"

registerBuildStep

writeVolumes
