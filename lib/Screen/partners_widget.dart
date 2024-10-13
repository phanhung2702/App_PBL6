import 'package:flutter/material.dart';

// Làm đối tác của Safely Travel
  final List<Map<String, String>> partners = [
    {
      'image': 'assets/Doi_tac/Doi_tac1.jpg',
      'name': 'Đối tác nhà xe',
    },
    {
      'image': 'assets/Doi_tac/Doi_tac2.jpg',
      'name': 'Đối tác tài xế',
    },
  ];

class PartnersWidget extends StatelessWidget {
  
  final List<Map<String, String>> partners;
  final Function onPartnerTap;

  const PartnersWidget({
    super.key,
    
    required this.partners,
    required this.onPartnerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đối tác của Safely Travel'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 72, 32),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 170, // Chiều cao cho mục đối tác
            child: PageView.builder(
              
              itemCount: (partners.length / 2).ceil(),
              itemBuilder: (context, pageIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (index) {
                      final partnerIndex = pageIndex * 2 + index;
                      if (partnerIndex < partners.length) {
                        final partner = partners[partnerIndex];
                        return GestureDetector(
                          onTap: () => onPartnerTap(),
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    partner['image']!,
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  partner['name']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(width: 100);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          
          
        ],
      ),
    );
  }
}
