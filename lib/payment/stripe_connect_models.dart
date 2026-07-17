import 'payment_models.dart';

enum StripeConnectRole {
  eventOrganizer,
  venueManager,
  unknown,
}

enum EventAcceptanceBlocker {
  none,
  vmConnectIncomplete,
  eoConnectIncomplete,
  paymentMethodRequired,
  stripeConfigurationMissing,
  networkError,
  unauthorized,
  validationError,
  retryableFailure,
}

class StripeConnectCopy {
  static StripeConnectRole roleFromStorage(String? role) {
    switch (role) {
      case 'eventOrganizer':
        return StripeConnectRole.eventOrganizer;
      case 'eventManager':
        return StripeConnectRole.venueManager;
      default:
        return StripeConnectRole.unknown;
    }
  }

  static String screenTitle(StripeConnectRole role) {
    return 'Payments & Payouts';
  }

  static String title(StripeConnectRole role) {
    switch (role) {
      case StripeConnectRole.eventOrganizer:
        return 'Complete Payout Setup';
      case StripeConnectRole.venueManager:
        return 'Complete Payment Account Setup';
      case StripeConnectRole.unknown:
        return 'Complete Stripe Setup';
    }
  }

  static String completeTitle(StripeConnectRole role) {
    switch (role) {
      case StripeConnectRole.eventOrganizer:
        return 'Payout Setup Complete';
      case StripeConnectRole.venueManager:
        return 'Payment Setup Complete';
      case StripeConnectRole.unknown:
        return 'Stripe Setup Complete';
    }
  }

  static String description(StripeConnectRole role) {
    switch (role) {
      case StripeConnectRole.eventOrganizer:
        return 'Connect your Stripe account so Groovkin can securely transfer event earnings to you.';
      case StripeConnectRole.venueManager:
        return 'Complete secure Stripe verification before accepting and paying for events through Groovkin.';
      case StripeConnectRole.unknown:
        return 'Complete secure Stripe verification to use Groovkin payments.';
    }
  }

  static String completeDescription(StripeConnectRole role) {
    switch (role) {
      case StripeConnectRole.eventOrganizer:
        return 'Your Stripe payout setup is complete and your account is ready for Groovkin payment workflows.';
      case StripeConnectRole.venueManager:
        return 'Your Stripe payment account setup is complete. Add a secure card before accepting event requests.';
      case StripeConnectRole.unknown:
        return 'Your Stripe setup is complete and ready for Groovkin payment workflows.';
    }
  }

  static String primaryButton(StripeConnectRole role) {
    switch (role) {
      case StripeConnectRole.eventOrganizer:
        return 'Complete Payout Setup';
      case StripeConnectRole.venueManager:
        return 'Complete Payment Setup';
      case StripeConnectRole.unknown:
        return 'Continue Stripe Setup';
    }
  }

  static String settingsMenuLabel(StripeConnectRole role) {
    switch (role) {
      case StripeConnectRole.eventOrganizer:
        return 'Payments & Payouts';
      case StripeConnectRole.venueManager:
        return 'Payments & Payouts';
      case StripeConnectRole.unknown:
        return 'Payments & Payouts';
    }
  }

  static String bannerMessage(StripeConnectRole role) {
    switch (role) {
      case StripeConnectRole.eventOrganizer:
        return 'Finish payout setup to receive event earnings through Groovkin.';
      case StripeConnectRole.venueManager:
        return 'Finish payment account setup before accepting paid events.';
      case StripeConnectRole.unknown:
        return 'Finish Stripe setup to continue with payments.';
    }
  }
}

class StripeConnectRequirementLabel {
  static const _labels = {
    'individual.address.city': 'Home address city',
    'individual.address.line1': 'Home address line 1',
    'individual.address.postal_code': 'Home address postal code',
    'individual.address.state': 'Home address state',
    'individual.dob.day': 'Date of birth day',
    'individual.dob.month': 'Date of birth month',
    'individual.dob.year': 'Date of birth year',
    'individual.email': 'Email address',
    'individual.first_name': 'Legal first name',
    'individual.last_name': 'Legal last name',
    'individual.phone': 'Phone number',
    'individual.ssn_last_4': 'Last 4 digits of SSN',
    'individual.id_number': 'Government ID number',
    'individual.verification.document': 'Identity document',
    'business_profile.url': 'Business website',
    'business_profile.mcc': 'Business category',
    'external_account': 'Bank account for payouts',
    'tos_acceptance.date': 'Terms of service acceptance',
    'tos_acceptance.ip': 'Terms of service acceptance',
    'company.address.city': 'Business address city',
    'company.address.line1': 'Business address line 1',
    'company.address.postal_code': 'Business address postal code',
    'company.address.state': 'Business address state',
    'company.name': 'Business legal name',
    'company.phone': 'Business phone number',
    'company.tax_id': 'Business tax ID',
    'representative.first_name': 'Representative first name',
    'representative.last_name': 'Representative last name',
    'representative.dob.day': 'Representative date of birth',
    'representative.dob.month': 'Representative date of birth',
    'representative.dob.year': 'Representative date of birth',
    'representative.address.city': 'Representative address city',
    'representative.address.line1': 'Representative address line 1',
    'representative.address.postal_code': 'Representative address postal code',
    'representative.address.state': 'Representative address state',
    'representative.email': 'Representative email',
    'representative.phone': 'Representative phone',
    'representative.ssn_last_4': 'Representative SSN last 4',
    'representative.id_number': 'Representative ID number',
    'representative.verification.document': 'Representative identity document',
  };

  static String labelFor(String requirement) {
    final normalized = requirement.trim();
    if (normalized.isEmpty) {
      return 'Additional verification information';
    }
    return _labels[normalized] ??
        normalized
            .split('.')
            .last
            .replaceAll('_', ' ')
            .split(' ')
            .map((part) => part.isEmpty
                ? part
                : '${part[0].toUpperCase()}${part.substring(1)}')
            .join(' ');
  }
}

bool isValidStripeOnboardingUrl(String? url) {
  if (url == null || url.trim().isEmpty) return false;
  final uri = Uri.tryParse(url.trim());
  if (uri == null || uri.scheme != 'https') return false;
  return uri.host.contains('stripe.com');
}

String maskConnectAccountId(String? accountId) {
  if (accountId == null || accountId.isEmpty) return 'Not started';
  if (accountId.length <= 8) return accountId;
  return '${accountId.substring(0, 4)}...${accountId.substring(accountId.length - 4)}';
}

EventAcceptanceBlocker resolveAcceptanceBlocker({
  required bool vmOnboardingComplete,
  required String? errorCode,
  int? httpStatus,
}) {
  if (errorCode == 'vm_connect_onboarding_incomplete') {
    return EventAcceptanceBlocker.vmConnectIncomplete;
  }
  if (errorCode == 'eo_connect_onboarding_incomplete') {
    return EventAcceptanceBlocker.eoConnectIncomplete;
  }
  if (errorCode == 'connect_onboarding_incomplete') {
    return vmOnboardingComplete
        ? EventAcceptanceBlocker.eoConnectIncomplete
        : EventAcceptanceBlocker.vmConnectIncomplete;
  }
  if (errorCode == 'payment_method_required') {
    return EventAcceptanceBlocker.paymentMethodRequired;
  }
  if (errorCode == 'stripe_configuration_missing') {
    return EventAcceptanceBlocker.stripeConfigurationMissing;
  }
  if (errorCode == 'unauthorized_payment_access' || httpStatus == 401) {
    return EventAcceptanceBlocker.unauthorized;
  }
  if (httpStatus == 422) {
    return EventAcceptanceBlocker.validationError;
  }
  if (httpStatus == 0 || httpStatus == null || httpStatus >= 500) {
    return EventAcceptanceBlocker.networkError;
  }
  return EventAcceptanceBlocker.retryableFailure;
}

/// Human label for the Verification row on the Payment & Payouts screen.
String connectVerificationLabel(StripeConnectStatus? status) {
  if (status == null) return 'Pending';
  if (status.onboardingComplete) return 'Complete';
  if (status.requirementsDue.isNotEmpty || !status.detailsSubmitted) {
    return 'Action needed';
  }
  return 'Pending';
}

bool connectStatusIsReady(StripeConnectStatus? status) {
  return status?.onboardingComplete == true &&
      status?.chargesEnabled == true &&
      status?.payoutsEnabled == true;
}

bool connectStatusNeedsAction(StripeConnectStatus? status) {
  if (status == null) return true;
  if (status.onboardingComplete) return false;
  return !status.detailsSubmitted || status.requirementsDue.isNotEmpty;
}
