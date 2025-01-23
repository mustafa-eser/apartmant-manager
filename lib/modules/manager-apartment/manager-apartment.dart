import 'package:apartmantmanager/global/index.dart';
import 'package:apartmantmanager/index.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class ManagerApartmentInfo extends StatefulWidget {
  const ManagerApartmentInfo({super.key});

  @override
  State<ManagerApartmentInfo> createState() => _ManagerApartmentInfoState();
}

class _ManagerApartmentInfoState extends State<ManagerApartmentInfo> {
  final manager = GetIt.I<ManagerService>();

  @override
  void initState() {
    GetIt.I<ManagerService>().apartmentInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Apartment Manager".tr())),
      body: StreamBuilder(
        stream: GetIt.I<ManagerService>().manager$,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildManagerInfoCard(context, width),
                  const SizedBox(height: 20),
                  _buildOptionsGrid(context, width),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildManagerInfoCard(BuildContext context, double width) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GlobalConfig.primaryColor.withAlpha(230),
            GlobalConfig.primaryColor.withValues(red: 60),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(4, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (manager.manager$.value?.first.name != null)
            Text(
              "${manager.manager$.value?.first.name}",
              style: AppTextStyles.cardTitle
                  .copyWith(color: Colors.white, fontSize: 17),
            ),
          const SizedBox(height: 8),
          if (manager.manager$.value?.first.manager != null)
            Row(
              children: [
                Text(
                  "Manager: ".tr(),
                  style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
                ),
                Text(
                  "${manager.manager$.value?.first.manager}",
                  style: AppTextStyles.bodyText.copyWith(color: Colors.white),
                ),
              ],
            ),
          const SizedBox(height: 8),
          if (manager.manager$.value?.first.address != null)
            Text(
              "${manager.manager$.value?.first.address}",
              style: AppTextStyles.bodyText.copyWith(color: Colors.white),
            ),
          const SizedBox(height: 12),
          if (manager.manager$.value?.first.managerphone != null)
            InkWell(
              onTap: () => launchUrl(Uri.parse(
                  'tel:${manager.manager$.value?.first.managerphone}')),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.call, color: GlobalConfig.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "${manager.manager$.value?.first.managerassistantphone}",
                      style: AppTextStyles.bodyText
                          .copyWith(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context, double width) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildManagerOption(
          context: context,
          title: "Add Apartment Guests".tr(),
          imageAsset: "assets/icons/apartments.png",
          firstColor: const Color(0xFF9628FA),
          secondColor: const Color(0xFF5F0FF8),
          onTap: () {
            Navigator.push(
              context,
              RouteAnimation.createRoute(const AddApartmentGuests(), 1, 0),
            );
          },
        ),
        _buildManagerOption(
          context: context,
          title: "Add Income & Expenses".tr(),
          imageAsset: "assets/icons/income.png",
          firstColor: const Color.fromARGB(255, 125, 206, 19),
          secondColor: const Color.fromARGB(255, 107, 189, 0),
          onTap: () {
            Navigator.push(
              context,
              RouteAnimation.createRoute(const AddIncomeExpenses(), 1, 0),
            );
          },
        ),
        _buildManagerOption(
          context: context,
          title: "Add Announcement".tr(),
          imageAsset: "assets/icons/notifications.png",
          firstColor: const Color(0xFF17B3FE),
          secondColor: const Color(0xFF0587FF),
          onTap: () {
            Navigator.push(
              context,
              RouteAnimation.createRoute(const AddAnnouncements(), 1, 0),
            );
          },
        ),
      ],
    );
  }

  Widget _buildManagerOption({
    required BuildContext context,
    required String title,
    required String imageAsset,
    required Color firstColor,
    required Color secondColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [firstColor.withAlpha(150), secondColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageAsset,
              width: 48,
              height: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
