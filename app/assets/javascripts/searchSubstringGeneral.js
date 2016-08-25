function isSubstring(searchterm,contact){
  var searchterm = searchterm.toLowerCase()

  var iterations= contact.name.length-searchterm.length+1

  if (iterations<0) {
    iterations = 0
  }

  for (i=0;i<=iterations;i++){
    var end_index = searchterm.length+i
    
    if (searchterm === contact.name.toLowerCase().slice(i,end_index)){
      return true
    }
  }
}
