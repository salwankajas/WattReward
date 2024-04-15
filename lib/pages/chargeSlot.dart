import 'package:flutter/material.dart';

class SelectSlot extends StatefulWidget {
  final int slot;
  SelectSlot({super.key, required this.slot});
  @override
  _SelectSlotState createState() => _SelectSlotState();
}

class _SelectSlotState extends State<SelectSlot> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    print(selectedIndex);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Select Charger",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Making the text bold
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height - 160,
              child: ListView.builder(
                  itemCount: widget.slot,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index; // Update the selected index
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 246, 246, 246),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.5), width: 0.5),
                        ),
                        margin: EdgeInsets.all(12),
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(12),
                              width: 90,
                              child: Image.asset(
                                "assets/images/icon/plug.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left:
                                        12), // Add padding to the left for the text
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Charger ${index + 1}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Radio<int>(
                                activeColor: Colors.green,
                                  value: index,
                                  groupValue: selectedIndex,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedIndex = value!;
                                    });
                                  },
                                ),
                              
                            )
                          ],
                        ),
                      ),
                    );
                  })),
          Positioned(
            bottom: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minimumSize: Size(280, 50),
                textStyle: TextStyle(fontSize: 16),
                // primary: Color.fromARGB(255, 99, 225, 103),
                // onPrimary: Colors.white,
                backgroundColor: Color.fromARGB(255, 99, 225, 103),
                foregroundColor: Colors.white,
                shadowColor: Color.fromARGB(255, 26, 255, 0),
                elevation: 4,
              ),
              child: Text("Continue",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onPressed: () => {
                
              },
            ),
          ),
        ]));
  }
}
