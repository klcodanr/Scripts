bundleContext.getBundles().each{ bundle ->
   def slingModelsPackages = bundle.getHeaders().get('Sling-Model-Packages');
   if(slingModelsPackages != null) {
       println "${bundle.getSymbolicName()} v${bundle.getVersion()}"
       println "  Models Packages: ${slingModelsPackages}"
       println ""
   }
}
