var formatter = {
        formatJSON: function(snapshot){
                const snap = snapshot.val();

                var jsonOBJ = JSON.stringify(snap, null, 4);
                return jsonOBJ;
        },
        removeChildrenFromJSON: function(snapshot){
                const snap = snapshot.val();
                let dict = []
                for (var key in snap){
                        dict.push(key);
                }
                return dict;
        }

}
module.exports = formatter;
