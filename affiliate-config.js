// Affiliate Link Configuration
// Update these URLs with your actual affiliate links

const AFFILIATE_LINKS = {
    // Debt Consolidation
    consolidation: {
        lendingtree: 'https://www.lendingtree.com/debt-consolidation?aid=[YOUR_AID]',
        sofi: 'https://www.sofi.com/personal-loans/?referrer=[YOUR_REF]',
        payoff: 'https://www.payoff.com/?ref=[YOUR_REF]',
        upstart: 'https://www.upstart.com/?ref=[YOUR_REF]'
    },

    // Balance Transfer Cards
    balanceTransfer: {
        cardRatings: 'https://www.cardratings.com/credit-card-list.html?aid=[YOUR_AID]',
        bankrate: 'https://www.bankrate.com/credit-cards/balance-transfer/?pid=[YOUR_PID]',
        nerdWallet: 'https://www.nerdwallet.com/best/credit-cards/balance-transfer?trk=[YOUR_TRK]'
    },

    // Personal Loans
    personalLoan: {
        lendingClub: 'https://www.lendingclub.com/personal-loans?aid=[YOUR_AID]',
        marcus: 'https://www.marcus.com/us/en/personal-loans?cid=[YOUR_CID]',
        discover: 'https://www.discover.com/personal-loans/?ICMPGN=PUB_HDR_PERSONALLOANS&ad=[YOUR_AD]'
    },

    // Credit Counseling
    creditCounseling: {
        nfcc: 'https://www.nfcc.org/?ref=[YOUR_REF]',
        moneymanagement: 'https://www.moneymanagement.org/?ref=[YOUR_REF]',
        consolidatedCredit: 'https://www.consolidatedcredit.org/?aid=[YOUR_AID]'
    },

    // Financial Tools
    tools: {
        mint: 'https://mint.intuit.com/?cid=[YOUR_CID]',
        ynab: 'https://www.ynab.com/?ref=[YOUR_REF]',
        personalCapital: 'https://www.personalcapital.com/?cid=[YOUR_CID]'
    }
};

// Commission Structure Reference
const COMMISSION_RATES = {
    lendingtree: { type: 'per-lead', amount: '$50-200', notes: 'Qualified loan application' },
    sofi: { type: 'per-funding', amount: '$150-300', notes: 'Loan must fund' },
    payoff: { type: 'per-loan', amount: '$100-200', notes: 'Completed loan' },
    upstart: { type: 'per-loan', amount: '$100-250', notes: 'Approved and funded' },
    cardRatings: { type: 'per-approval', amount: '$50-100', notes: 'Card approval' },
    bankrate: { type: 'per-click', amount: '$1-5', notes: 'High volume potential' },
    nfcc: { type: 'per-enrollment', amount: '$25-50', notes: 'DMP enrollment' }
};

// Smart Link Routing
// Routes users to best offer based on their debt profile
function getSmartAffiliateLink(debtProfile) {
    const { totalDebt, avgInterestRate, numDebts } = debtProfile;

    // High-interest credit card debt → Balance transfer
    if (avgInterestRate > 15 && numDebts <= 3) {
        return AFFILIATE_LINKS.balanceTransfer.cardRatings;
    }

    // Multiple high-balance debts → Consolidation loan
    if (totalDebt > 10000 && numDebts >= 3) {
        return AFFILIATE_LINKS.consolidation.lendingtree;
    }

    // Struggling with payments → Credit counseling
    if (totalDebt > 20000) {
        return AFFILIATE_LINKS.creditCounseling.nfcc;
    }

    // Default → Personal loan comparison
    return AFFILIATE_LINKS.personalLoan.lendingClub;
}

// Tracking Function
function trackAffiliateClick(type, destination) {
    // Google Analytics 4 event
    if (typeof gtag !== 'undefined') {
        gtag('event', 'affiliate_click', {
            event_category: 'affiliate',
            event_label: type,
            destination: destination
        });
    }

    // Facebook Pixel
    if (typeof fbq !== 'undefined') {
        fbq('track', 'InitiateCheckout', {
            content_type: 'affiliate_link',
            content_ids: [type]
        });
    }

    // Custom tracking
    console.log(`Affiliate click: ${type} -> ${destination}`);
}

// Export for use in main app
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        AFFILIATE_LINKS,
        COMMISSION_RATES,
        getSmartAffiliateLink,
        trackAffiliateClick
    };
}
