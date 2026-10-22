# Mapping from `mesh systems.xlsm`

| Workbook sheet | Fields / existing purpose | Planned application module |
|---|---|---|
| `Setup` | School name, postal address, telephone, academic year, head teacher, motto; grade thresholds, points, remarks; class and class teacher | School profile, academic year, grading configuration, classes and teacher assignments |
| `Students` | Admission number, student name, class, stream | Student register and class/stream assignments |
| `Marksentry` | Admission number, student name lookup, subject scores, total | Examination records and mark entry by student/subject/exam |
| `Reportcard` | Student identity, subject marks, grades, points, positions, remarks and totals | Printable student report cards, configurable grading rules and class performance |
| `Dashboard` | Workbook dashboard sheet (currently no visible cell data detected) | School-level KPIs, attendance, fees and academic summaries |

Workbook subjects detected in marks entry: English, Kiswahili, Maths, Integrated Science, Agriculture, SST, CRE, CAS and PRT. Labels can be renamed to each school's current curriculum. Existing formulas use `XLOOKUP`, totals and array formulas; calculations need validation against the school's intended grading policy before production use.
