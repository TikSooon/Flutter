import 'package:flutter/material.dart';
import 'Classes/project_model.dart';

class BeatPage extends StatefulWidget {
  List<ProjectModel> model;
  int index;

  BeatPage(this.index, this.model);

  @override
  State<BeatPage> createState() => _BeatPageState();
}

class _BeatPageState extends State<BeatPage> {
  bool isOpenExpand = true;
  bool pressGeoON = false;
  bool cmbscritta = false;

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0;

    return
      GestureDetector(
          onTap:(){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
      backgroundColor: Color(0xff1E1E1E),
      body: Column(
        children: [
          //Total Beat card
          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(),
            child: ListTile(
              leading: Image(
                image: AssetImage('assets/picture/Bar_graph.jpeg'),
              ),
              contentPadding: EdgeInsets.only(
                  left: 40.0, top: 20.0, right: 60.0, bottom: 22.0),
              title: Text(
                "Total Beats",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              trailing: Text(
                '${widget.model[widget.index].SecondPageModelList.length + 0}',
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            margin: EdgeInsets.all(10.0),
          ),

          Expanded(
            flex: 20,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                widget.model[widget.index].SecondPageModelList.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            "Click + to add new beat",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Column(
                        children: [

                          Padding(
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    pressGeoON = !pressGeoON;
                                    cmbscritta = !cmbscritta;
                                  });
                                },
                                child: cmbscritta
                                    ? Text(
                                  'Collapse All',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xffc96d6d)),
                                )
                                    : Text(
                                  'Hide All',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xffc96d6d)),
                                ),
                              ),
                            ),
                          ),

                          //list
                          Container(
                            child: Theme(
                              data: ThemeData(canvasColor: Colors.transparent),
                              child: ReorderableListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.model[widget.index]
                                    .SecondPageModelList.length,
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (newIndex > oldIndex) {
                                      newIndex -= 1;
                                    }
                                    final element = widget
                                        .model[widget.index].SecondPageModelList
                                        .removeAt(oldIndex);
                                    widget
                                        .model[widget.index].SecondPageModelList
                                        .insert(newIndex, element);
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    onDismissed: (position) {
                                      setState(() {
                                        widget.model[widget.index]
                                            .SecondPageModelList
                                            .removeAt(index);
                                      });
                                    },
                                    background: Container(
                                      color: Colors.blue,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 25),
                                      child: Icon(Icons.folder),
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 25),
                                      child: Icon(Icons.delete),
                                    ),
                                    key: ValueKey(widget.model[widget.index]
                                        .SecondPageModelList[index]),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            color: Colors.white10,
                                            padding: EdgeInsets.all(5.0),
                                            margin: EdgeInsets.all(10.0),
                                            child: ExpansionTile(
                                              iconColor: Color(0xffc96d6d),
                                              collapsedIconColor:
                                                  Color(0xffc96d6d),
                                              title: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 0.01,
                                                            right: 8),
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.lightBlue,
                                                          fontSize: 60,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: TextField(
                                                      textInputAction: TextInputAction.go,
                                                      controller: widget
                                                          .model[widget.index]
                                                          .SecondPageModelList[
                                                              index]
                                                          .beats,
                                                      maxLines: null,
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Beats",
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 350,
                                                      child: Divider(
                                                        thickness: 2,
                                                        height: 5,
                                                        color: Colors.white38,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 320,
                                                      child: TextField(
                                                        textInputAction: TextInputAction.go,
                                                        controller: widget
                                                            .model[widget.index]
                                                            .SecondPageModelList[
                                                                index]
                                                            .body,
                                                        maxLines: null,
                                                        textAlign:
                                                            TextAlign.start,
                                                        autofocus: true,
                                                        style: TextStyle(
                                                          color: Colors.white60,
                                                          fontSize: 20,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "Body",
                                                          hintStyle: TextStyle(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 20,
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // itemExpand(widget.model[widget.index].SecondPageModelList[index].body, widget.model[widget.index].SecondPageModelList[index].isExpanded ),
                                              ],
                                              trailing: Icon(
                                                widget
                                                        .model[widget.index]
                                                        .SecondPageModelList[
                                                            index]
                                                        .isExpanded
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                size: 45,
                                                color: Color(0xffc96d6d),
                                              ),
                                              onExpansionChanged:
                                                  (bool expand) {
                                                setState(() {
                                                  widget
                                                      .model[widget.index]
                                                      .SecondPageModelList[
                                                          index]
                                                      .isExpanded = expand;
                                                  expand = isOpenExpand;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),

        ],
      ),

      //Add button
      floatingActionButton: Visibility(
        visible: showFab,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              widget.model[widget.index].SecondPageModelList
                  .add(SecondPageModel());
            });
          },
          backgroundColor: Colors.pink, //Colors.white30,
          child: Icon(
            Icons.add_sharp,
            size: 30,
            color: Colors.white, //Colors.white,
          ), //icon inside button
        ),
      ),
          ),
          );
  }
}
