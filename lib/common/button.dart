// import 'package:note/import.dart';
// class MyButton extends StatelessWidget {
//   const MyButton({
//     Key? key,
//     required this.label,
//     required this.onTap,
//     required this.color,
//   }) : super(key: key);
//
//   final dynamic label;
//   final Function() onTap;
//   final Color? color;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         alignment: Alignment.center,
//         width: 100,
//         height: 45,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: color,
//         ),
//         child: label is Widget ? label :Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
