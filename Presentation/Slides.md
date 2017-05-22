How to deal with email leaks
========================================================
author: Alexandre Léchenet & Hervé Letoqueux
date: May 2017
autosize: true


<style>
.midcenter {
    position: fixed;
    top: 100%;
    left: 50%;
}
</style>

<div class="midcenter" style="margin-left:-420px; margin-top:-350px;">
<img src="Slides-figure/EIJC17.png"></img>
</div>



What we'll talk about
========================================================
incremental: true

- Why this workshop?
- Some techy stuff
- Tools
- Conclusion and question time!

Details on this presentation are available on Github!</br>
Please visit <https://github.com/alphoenix/Mail-EIJC17>.

Why this workshop
========================================================
incremental: true
Latest examples
In most cases, hacks are made public for bad rather than whistleblowing

    Sony hack
    Stratfor mails
    Hacking Team dump
    DNC mail leak
    Macronleaks

Some mailboxes are in HDs found during an investigation (Offshore Leaks, Panama Papers...)

Ethics of using the leaks
========================================================
incremental: true

 - *«The new role of journalists, for better or for worse, isn’t as gatekeepers, but interpreters: If they don’t parse it, others without the experience, credentials, or mindfulness toward protecting personal information certainly will.»*
 - *«That hesitance, however, is at least in part responsible for the quality, and character, of much of the reporting thus far.»*</br>
 <a href='https://www.buzzfeed.com/annehelenpetersen/complicated-sony-ethics'>Ann Helen Petersen in Buzzfeed - 2014</a>
 - *«Before reporting on information from a hack, ask yourself this: Would you go to great lengths to find a way to hack or leak this information if it wasn’t just conveniently dumped in front of you? If not, it’s probably not newsworthy enough to report on.»*</br>
 <a href='https://www.buzzfeed.com/zeyneptufekci/dear-france-you-just-got-hacked-dont-make-the-same-mistakes'>Zeyneb Tufekci in Buzzfeed - 2017</a>


Some techy stuff... sorry about that...
========================================================
incremental: true

- What's an email?
- Formats : mbox, eml, maildir, pst...

  Some obvious infos that will lead the investigation :

- Sender and receiver(s) : Quantify and qualify links between persons and entities
- Body : Content and semantic analysis...
- Headers : Technical infos (like IP adresses, OS, Timestamp, etc.. ). Useful for context and verification of the leak
- Attachments : Format? Type? 

Different visualizations possible, for a good story...
========================================================
incremental: true

- Relationships between people (Networks)
- Stats on volumes, quantity, etc...
- Amounts on pro format and invoices in attachments...
- Geographical distribution (maps)
- etc...


Tools !!! Import, convert, export and parse...
========================================================
incremental: true
- <b>Grep</b> - Ok this is hard beginning... But it works!
- Importing mails in Thunderbird : <b>ImportExportTools plugin</b></br>
Please visit <https://addons.mozilla.org/fr/thunderbird/addon/importexporttools/>
Enhance TB's ability to bulk import mails. Export a mailbox in csv files!
- Converting a pst file in eml files : <b>libpst</b></br>
Please visit <http://www.five-ten-sg.com/libpst/></br>
Simply type :

```bash
readpst -r Outlook.pst
```
- <b>Mailraider</b> for OSX : <https://www.45rpmsoftware.com/mailraider.php>

Tools !!! Datacleansing and Visualizing...
========================================================
incremental: true
- <b>Openrefine</b>
- <b>Gephi</b>
- <b>D3js</b>


Tools !!! Index search and tag...
========================================================
incremental: true
- <b>Overview Docs</b> : The open source document mining platform
</br>Please visit <https://www.overviewdocs.com/></br>
- <b>OpenSemanticSearch</b> Integrated research tools for easier searching, monitoring, analytics, discovery & text mining of heterogenous & large document sets & news with free software on your own server
</br>Please visit <https://www.opensemanticsearch.org/></br>
- <b>DocFetcher</b> : Simple standalone yet efficient application for indexing and searching documents.
</br>Please visit <http://docfetcher.sourceforge.net/en/index.html>
- <b>Bulkextractor</b> : computer forensics tool that scans a disk image, a file, or a directory of files and extracts useful information </br>Please visit <http://www.forensicswiki.org/wiki/Bulk_extractor>

Tools !!! Just like beer, homebrewing...
========================================================
incremental: true
- A mail parser using python <https://github.com/SpamScope/mail-parser>
- Alexandre's homebrew script using python (used on (cini)² case )
- <b>Mailbox-with-R</b>, Hervé's solution using R : available in this repo
- Always think about Semantic Analysis : </br>
Useful to Quickly evaluate the interest of a mailbox, the context</br>
Useful to build homemade dictionaries to break passwords!</br>
A nice R package : <https://cran.r-project.org/web/packages/tm.plugin.mail/tm.plugin.mail.pdf>



Conclusion
========================================================
incremental: true
- Main difficulties : 

  - Encoding sucks. I mean... Really!
  - Low volume of emails available
  - Unique sender...</br>
    These two factors produce biases in interpretation

- Really useful analysis!

Question time
========================================================


References
========================================================
- Visual Discovery of Communication Patterns in Email Networks</br>
Benjamin Bengfort and Konstantinos Xirogiannopoulos </br> <http://cs.umd.edu/~bengfort/papers/visual-discovery-email-networks.pdf>
- A Rather Nosy Topic Model Analysis of the Enron Email Corpus - R-Bloggers</br> <https://www.r-bloggers.com/a-rather-nosy-topic-model-analysis-of-the-enron-email-corpus/>
- Email analysis and information extraction for entreprise benefit
<http://ontea.sourceforge.net/publications/laclavik_ie_cai_final.pdf>
- Work on the metadata and what they say
<https://labs.rs/en/metadata/>
- BDD Hacking Team
<https://wikileaks.org/hackingteam/emails/>

