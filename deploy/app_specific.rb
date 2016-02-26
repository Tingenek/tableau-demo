#
# Put your custom functions in this class in order to keep the files under lib untainted
#
# This class has access to all of the private variables in deploy/lib/server_config.rb
#
# any public method you create here can be called from the command line. See
# the examples below for more information.
#
class ServerConfig

   def my_custom_method()
    # since we are monkey patching we have access to the private methods
     # in ServerConfig
     @logger.info(@properties["ml.content-db"])
   end

  def make_views()
  r = execute_query %Q{
      xquery version "1.0-ml"; 
      
      import module namespace view = "http://marklogic.com/xdmp/view" at "/MarkLogic/views.xqy";

  
  	xdmp:log("Creating views.."),

        try {
           view:remove("main","prescriptions"),
           view:remove("main","employees"),
           view:remove("main","expenses")
        } catch ($ignore) {
        };

	xquery version "1.0-ml"; 
 
    import module namespace view = "http://marklogic.com/xdmp/view" at "/MarkLogic/views.xqy";

	  view:create(
      "main",
      "prescriptions",
       view:element-view-scope(fn:QName("http://nhs.prescriptions.com","prescription")),
      ( view:column("uri", cts:uri-reference()), 
            view:column("section_name", cts:element-reference(fn:QName("http://nhs.prescriptions.com", "section_name"))),
            view:column("chapter_name", cts:element-reference(fn:QName("http://nhs.prescriptions.com", "chapter_name"))),
            view:column("actual_cost", cts:element-reference(fn:QName("http://nhs.prescriptions.com", "actual_cost"))),
            view:column("items", cts:element-reference(fn:QName("http://nhs.prescriptions.com", "items"))),
            view:column("id", cts:element-reference(fn:QName("http://nhs.prescriptions.com", "id")))
      )     
      ,
      () ),
         
      view:create(
      "main",
      "employees",
       view:element-view-scope(fn:QName("","Employee")),
      ( view:column("uri", cts:uri-reference()), 
            view:column("employeeid", cts:element-reference(fn:QName("","EmployeeID"))),
            view:column("firstname", cts:element-reference(fn:QName("","FirstName"))),
            view:column("lastname", cts:element-reference(fn:QName("","LastName")))
      )     
      ,
      () ),
      
      view:create(
      "main",
      "expenses",
       view:element-view-scope(fn:QName("","Employee")),
      ( view:column("uri", cts:uri-reference()), 
            view:column("employeeid", cts:element-reference(fn:QName("","EmployeeID"))),
            view:column("data", cts:element-reference(fn:QName("","Date"))),
            view:column("amount", cts:element-reference(fn:QName("","Amount")))
      )     
      ,
      () )
      
    },
    { :db_name => @properties["ml.content-db"] }
    logger.info "created prescriptions, expenses and employee views"
  end 
      
end
  
#
# Uncomment, and adjust below code to get help about your app_specific
# commands included into Roxy help. (ml -h)
#

#class Help
#  def self.app_specific
#    <<-DOC.strip_heredoc
#
#      App-specific commands:
#        example       Installs app-specific alerting
#    DOC
#  end
#
#  def self.example
#    <<-DOC.strip_heredoc
#      Usage: ml {env} example [args] [options]
#      
#      Runs a special example task against given environment.
#      
#      Arguments:
#        this    Do this
#        that    Do that
#        
#      Options:
#        --whatever=value
#    DOC
#  end
#end
