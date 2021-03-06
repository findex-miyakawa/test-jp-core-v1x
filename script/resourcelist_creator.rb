require "json"
genenareted = "./fsh-generated/resources/"
work = "./temp/scriptwork/"
linkpage= work + "resource_info.csv"

#--- 種別指定書き込み処理 ---
def putRecord(prefix, fw, extension = false)
    files = Dir.glob(prefix + "-*.json")
    for fl in files
        File.open(fl) do |f|
            h = JSON.load(f)
            if (h["type"] == "Extension") == extension then
              fw.puts  fl + "," + h["resourceType"].to_s + "," + h["type"].to_s + "," + h["id"].to_s + "," + h["name"].to_s + "," + h["title"].to_s + "," + h["url"].to_s
            end
        end
    end
end

begin
  if !Dir.exists?(work) then
    p "mkdir:" + work
    Dir.mkdir(work)
  end
  File.open(linkpage,"w") do |fw|
    Dir.chdir(genenareted)
    fw.puts  "path,resourceType,type,id,name,title,url"
           
    putRecord("ImplementationGuide", fw)
    putRecord("StructureDefinition", fw)
    putRecord("StructureDefinition", fw, true)
    putRecord("CapabilityStatement", fw)
    putRecord("SearchParameter", fw)
    putRecord("CodeSystem", fw)
    putRecord("ValueSet", fw)
  end 
end
