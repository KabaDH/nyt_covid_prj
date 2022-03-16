import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyt_covid_prj/services/palette.dart';
import 'package:nyt_covid_prj/widgets/widgets.dart';

class InfoScreen extends StatelessWidget {
  var s1 = Singleton.instance;

  @override
  Widget build(BuildContext context) {
    s1.currentIndex = 2;

    paragraf(String header, String bodyTex) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 24),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              bodyTex,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 14, letterSpacing: 1.2, color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppbar(),
      drawer: CustomDrawer(),
      body: Container(
          color: Palette.primaryColor,
          child: ListView(
            children: [
              paragraf('"Probable" and “Confirmed Cases and Deaths',
                  'Cases and deaths can be reported as either “confirmed” or “probable.” Our total cases and deaths include both. The number of cases includes all cases, including those who have since recovered or died. On April 5, 2020, the Council of State and Territorial Epidemiologists advised states to include both confirmed cases, based on confirmatory laboratory testing, and probable cases, based on specific criteria for testing, symptoms and exposure. The Centers for Disease Control adopted these definitions and national CDC data began including confirmed and probable cases on April 14, 2020. Some governments continue to report only confirmed cases, while others are reporting both confirmed and probable numbers. And there is also another set of governments that is reporting the two types of numbers combined without providing a way to separate the confirmed from the probable. The Geographic Exceptions section below has more details on specific areas. The methodology of individual states changes frequently.'),
              paragraf('Confirmed Cases',
                  'Confirmed cases are counts of individuals whose coronavirus infections were confirmed by a laboratory test and reported by a federal, state, territorial or local government agency. Only tests that detect viral RNA in a sample are considered confirmatory. These are often called molecular or RT-PCR tests.'),
              paragraf('Probable Cases',
                  'Probable cases count individuals who did not have a confirmed test but were evaluated by public health officials using criteria developed by states and the federal government and reported by a health department. Public health officials consider laboratory, epidemiological, clinical and vital records evidence. Tests that detect antigens or antibodies are considered evidence towards a “probable” case, but are not sufficient on their own, according to the Council of State and Territorial Epidemiologists.'),
              paragraf('Confirmed Deaths',
                  'Confirmed deaths are individuals who have died and meet the definition for a confirmed Covid-19 case. Some states reconcile these records with death certificates to remove deaths from their count where Covid-19 is not listed as the cause of death. We follow health departments in removing non-Covid-19 deaths among confirmed cases when we have information to unambiguously know the deaths were not due to Covid-19, i.e. in cases of homicide, suicide, car crash or drug overdose.'),
              paragraf('"Probable” Deaths"',
                  'Probable deaths are deaths where Covid-19 is listed on the death certificate as the cause of death or a significant contributing condition, but where there has been no positive confirmatory laboratory test. Deaths among probable cases tracked by a state or local health department where a death certificate has not yet been filed may also be counted as a probable death.')
            ],
          )),
    );
  }
}
