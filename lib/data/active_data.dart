import '../models/portfolio_data.dart';
import 'default_portfolio.dart';

PortfolioData _active = buildDefaultPortfolio();

PortfolioData get activeData => _active;

void setActivePortfolio(PortfolioData data) {
  _active = data;
}