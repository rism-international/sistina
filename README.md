# README

This project converts a FileMaker Database to MarcXML record. The transfer is done via an API. The result is designed for beeing used with muscat. The whole design is set up for a particular dataset concerning the Fondo Cappella Sistina, that resides in the input folder.

References:

https://github.com/rism-ch/muscat

The Project is configured to run both, the sistina app and the muscat app on seperate rails servers.

# Import

To get the data into the rails environment you first start rails from the root directory

```
cd ~/projects/sistina
rails s 0.0.0.0
```

Then you open the rails console (it might be necessary to stop string...):

```
spring stop && bin/rails c
```

The Import Class in the models directory is responsible to transform the FM-Database into the local db.

```
i = Import.new
i.populate
```

# Export

The Export into an xml-File is done from the Code Class in sistina/app/models/code.rb.
The call in irb is like this:
```
Code.export
```

The result is written to sistina/export/

# Indexing in Muscat

The Indexing of the Muscat data is described in the Muscat Package. More sophisticated and sometimes faster runs are described in short here:

The reindexing of the Sources only can be done like this:
```
bin/rails 'sunspot:solr:reindex[,Source]'
```
