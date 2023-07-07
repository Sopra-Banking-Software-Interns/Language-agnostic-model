linenumber=$(sed -n '$=' dependency_present.txt)
for (( x=1; x<=$linenumber; x++ ))
do
linew=$(sed -n "${x}p" dependency_present.txt)
if [[ $linew == "requirements.txt" ]]
then
./python_req.sh
fi
if [[ $linew == "build.gradle" ]]
then
./gradle.sh
fi
if [[ $linew == "pom.xml" ]]
then
./maven.sh
fi
if [[ $linew == "gemfile" ]]
then
./ruby_gemfile.sh
fi
if [[ $linew == "cargo.toml" ]]
then
./cargo.sh
fi
if [[ $linew == "package.yaml" ]]
then
./haskell.sh
fi
if [[ $linew == "composer.json" ]]
then
./php.sh
fi
if [[ $linew == "package.swift" ]]
then
./swift.sh
fi
if [[ $linew == "packages.config" ]]
then
./csharp.sh
fi
done
